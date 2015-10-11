//
//  FMAMessageBoardVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/26/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAMessageBoardVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMABackgroundSetting.h"

#define EMPTY_LABEL_TEXT                        @"No Message(s) Found"

// Interval in seconds to check if the other user sent a message
#define CHECK_INTERVAL                          3.0

static NSString * const kJSQDemoAvatarNameCook = @"Mike";
static NSString * const kJSQDemoAvatarNameJobs = @"John";
static NSString * const kJSQDemoAvatarNameWoz  = @"David";

#define DEMO_AVATAR_IMAGE   @"00_empty_avatar"

@interface FMAMessageBoardVC ()

@end

@implementation FMAMessageBoardVC
{
    NSMutableArray *dataSource;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAMessageBoardVC) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self printLogWith:@"initWithCoder"];
    
    if ((self = [super initWithCoder:aDecoder]))
    {
    }
    return self;
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
    [self initMessageVC];
    [self initDataSource];
    [self startTimer];
}

- (void)didReceiveMemoryWarning
{
    [self printLogWith:@"didReceiveMemoryWarning"];
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initViewBackground];
    
    self.collectionView.backgroundView  = self.labelEmpty;
    
    _hud = [FMAUtil initHUDWithView:self.view];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    self.collectionView.clipsToBounds = YES;
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForMessageVC:self];
    [FMAThemeManager setBackgroundImageForName:_backgroundName toImageView:_imageviewBackground];
    [FMAThemeManager setBackgroundImageForName:_backgroundName toNavigationBar:self.navigationController.navigationBar withPrompt:NO];
    
    [FMABackgroundUtil requestBackgroundForName:_backgroundName delegate:self];
}

- (void)initMessageVC
{
    self.sender = [PFUser currentUser].objectId;
    
//    [self setupTestModel];
    
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
    self.outgoingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    outgoingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    
    self.incomingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    incomingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    NSDictionary *datetimeTextAttributes = @{NSForegroundColorAttributeName : RGBHEX(0xffffff, 1.f)};
    [[JSQMessagesTimestampFormatter sharedFormatter] setDateTextAttributes:datetimeTextAttributes];
    [[JSQMessagesTimestampFormatter sharedFormatter] setTimeTextAttributes:datetimeTextAttributes];
    
    CGFloat incomingDiameter = self.collectionView.collectionViewLayout.incomingAvatarViewSize.width;
    
    UIImage *otherImage = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:DEMO_AVATAR_IMAGE]
                                                           diameter:incomingDiameter];
    
    self.avatars = @{ @"default" : otherImage, };
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMAThemeManager setBackgroundImageForName:_backgroundName toImageView:_imageviewBackground];
        [FMAThemeManager setBackgroundImageForName:_backgroundName toNavigationBar:self.navigationController.navigationBar withPrompt:NO];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Data Source Functions
- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    [self sendRequest];
}

- (void)sendRequest
{
    [self printLogWith:@"sendRequest"];
    
    _bRegularLoading = YES;
    
    [FMAUtil showHUD:_hud withText:@""];
    
    [FMAMessageBoardUtil requestGetMessagesInMessageBoardPageWithFilterParams:[dataSource count] delegate:self];
}

- (void)requestGetMessagesInMessageBoardPageWithFilterParamsDidRespondWithMessages:(NSArray *)messages
{
    [self printLogWith:@"requestGetMessagesInMessageBoardPageWithFilterParamsDidRespondWithMessages"];
    
    _bRegularLoading = NO;
    
    [_hud hide:YES];
    
    if ([FMAUtil isObjectEmpty:dataSource])
    {
        dataSource = [NSMutableArray array];
    }
    
    [dataSource addObjectsFromArray:messages];
    
    [self addMessagesFromObjects:messages];
    
    [self.collectionView reloadData];
    
    [self layoutEmptyLabel];
}

- (void)addMessagesFromObjects:(NSArray *)messageObjects
{
    [self printLogWith:@"addMessagesFromObjects"];
    
    if ([FMAUtil isObjectEmpty:_messages])
    {
        _messages = [NSMutableArray array];
    }
    
    for (PFObject *m in messageObjects)
    {
        NSString     *senderId = [FMAMessageBoardUtil senderIDFromMessage:m];
        JSQMessage *jsqMessage = [[JSQMessage alloc] initWithText:m[kFMMessageTextKey] sender:senderId date:m.updatedAt];
        
        [_messages insertObject:jsqMessage atIndex:0];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Timer Functions
- (void)sendRequestForLatestMessages:(id)sender
{
    [self printLogWith:@"sendRequestForLatestMessages"];
    
    if (_bRegularLoading || _bTimerLoading) return;
    
    NSDate *lastDate = [NSDate date];
    if ([dataSource count] > 0)
    {
        PFObject *latestMessage = [dataSource objectAtIndex:0];
        lastDate = latestMessage.updatedAt;
    }
    
    
    [FMAMessageBoardUtil requestGetLatestMessagesInMessageBoardPageWithFilterParams:lastDate delegate:self];
    
    _bTimerLoading = YES;
}

- (void)requestGetLatestMessagesInMessageBoardPageWithFilterParamsDidRespondWithMessages:(NSArray *)messages
{
    [self printLogWith:@"requestGetLatestMessagesInMessageBoardPageWithFilterParamsDidRespondWithMessages"];
    
    _bTimerLoading = NO;
    
    if ([FMAUtil isObjectEmpty:dataSource])
    {
        dataSource = [NSMutableArray array];
    }
    
    // Filter new messages
    NSMutableArray *newMessages = [NSMutableArray array];
    for (NSInteger i=[messages count]-1; i>=0; i--)
    {
        PFObject *m = [messages objectAtIndex:i];
        
        NSUInteger index = [FMAUtil indexOfPFObject:m InObjects:dataSource];
        
        if (index == NSNotFound)
        {
            [dataSource insertObject:m atIndex:0];
            [newMessages addObject:m];
        }
    }
    
    if ([newMessages count]>0)
    {
        [self addNewMessagesFromObjects:newMessages];
        [self.collectionView reloadData];
        [self layoutEmptyLabel];
        
        [self scrollToBottomAnimated:YES];
    }
}

- (void)addNewMessagesFromObjects:(NSArray *)messageObjects
{
    [self printLogWith:@"addNewMessagesFromObjects"];
    
    if ([FMAUtil isObjectEmpty:_messages])
    {
        _messages = [NSMutableArray array];
    }
    
    for (PFObject *m in messageObjects)
    {
        NSString     *senderId = [FMAMessageBoardUtil senderIDFromMessage:m];
        JSQMessage *jsqMessage = [[JSQMessage alloc] initWithText:m[kFMMessageTextKey] sender:senderId date:m.updatedAt];
        
        [_messages addObject:jsqMessage];
    }
}

- (void)startTimer
{
    [self printLogWith:@"startTimer"];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:CHECK_INTERVAL
                                                  target:self
                                                selector:@selector(sendRequestForLatestMessages:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)invalidateTimer
{
    [self printLogWith:@"invalidateTimer"];
    
    [_timer invalidate];
    _timer = nil;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Empty Label Functions
- (UILabel *)labelEmpty
{
    [self printLogWith:@"emptyLabel"];
    
    if (!_labelEmpty)
    {
        UILabel *label = [[UILabel alloc] init];
        
        CGRect rect = self.collectionView.frame;
        rect.origin = CGPointMake(0.f, 0.f);
        label.frame = rect;
        label.text  = EMPTY_LABEL_TEXT;
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font          = COMMON_FONT_FOR_EMPTY_LISTVIEW_LABEL;
        label.textColor     = COMMON_COLOR_FOR_EMPTY_LISTVIEW_LABEL;
        
        _labelEmpty = label;
    }
    
    return _labelEmpty;
}

- (void)layoutEmptyLabel
{
    [self printLogWith:@"layoutEmptyLabel"];
    
    if ([dataSource count] > 0)
    {
        self.labelEmpty.text = @"";
    }
    else
    {
        self.labelEmpty.text = EMPTY_LABEL_TEXT;
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self invalidateTimer];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [FMAUtil appDelegate].currentMessageVC = nil;
    }];
}

- (IBAction)onBtnMore:(id)sender
{
    [self printLogWith:@"onBtnMore"];
    
    [self sendRequest];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Demo setup
- (void)setupTestModel
{
    self.messages = [[NSMutableArray alloc] initWithObjects:
                     [[JSQMessage alloc] initWithText:@"Thank you for your message." sender:self.sender date:[NSDate distantPast]],
                     [[JSQMessage alloc] initWithText:@"This looks amazing. :)" sender:kJSQDemoAvatarNameWoz date:[NSDate distantPast]],
                     [[JSQMessage alloc] initWithText:@"Did you get my email?" sender:self.sender date:[NSDate distantPast]],
                     [[JSQMessage alloc] initWithText:@"Yes, I did." sender:kJSQDemoAvatarNameJobs date:[NSDate date]],
                     [[JSQMessage alloc] initWithText:@"That sounds great!" sender:kJSQDemoAvatarNameCook date:[NSDate date]],
                     [[JSQMessage alloc] initWithText:@"I see that the chair is comfortable." sender:self.sender date:[NSDate date]],
                     nil];
    
    //    CGFloat outgoingDiameter = self.collectionView.collectionViewLayout.outgoingAvatarViewSize.width;
    
    CGFloat incomingDiameter = self.collectionView.collectionViewLayout.incomingAvatarViewSize.width;
    
    UIImage *jsqImage = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:DEMO_AVATAR_IMAGE]
                                                         diameter:incomingDiameter];
    
    
    UIImage *cookImage = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:DEMO_AVATAR_IMAGE]
                                                          diameter:incomingDiameter];
    
    UIImage *jobsImage = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:DEMO_AVATAR_IMAGE]
                                                          diameter:incomingDiameter];
    
    UIImage *wozImage = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:DEMO_AVATAR_IMAGE]
                                                         diameter:incomingDiameter];
    self.avatars = @{ self.sender : jsqImage,
                      kJSQDemoAvatarNameCook : cookImage,
                      kJSQDemoAvatarNameJobs : jobsImage,
                      kJSQDemoAvatarNameWoz : wozImage };
    
    NSUInteger messagesToAdd = 0;
    NSArray *copyOfMessages = [self.messages copy];
    for (NSUInteger i = 0; i < messagesToAdd; i++) {
        [self.messages addObjectsFromArray:copyOfMessages];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - JSQMessagesViewController method overrides
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                    sender:(NSString *)sender
                      date:(NSDate *)date
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithText:text sender:sender date:date];
    [self.messages addObject:message];
    
    [self finishSendingMessage];
    
    PFObject *m = [PFObject objectWithClassName:kFMMessageClassKey];
    
    m[kFMMessageFromKey] = [PFUser currentUser];
    m[kFMMessageTextKey] = text;
    
    [m saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (error)
        {
            [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
        }
        else
        {
            [dataSource insertObject:m atIndex:0];
        }
    }];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    NSLog(@"Camera pressed!");
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - JSQMessages CollectionView DataSource
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.sender isEqualToString:self.sender]) {
        return [[UIImageView alloc] initWithImage:self.outgoingBubbleImageView.image
                                 highlightedImage:self.outgoingBubbleImageView.highlightedImage];
    }
    
    return [[UIImageView alloc] initWithImage:self.incomingBubbleImageView.image
                             highlightedImage:self.incomingBubbleImageView.highlightedImage];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.sender isEqualToString:self.sender]) return nil;
    
    UIImage *avatarImage = [self.avatars objectForKey:@"default"];
    return [[UIImageView alloc] initWithImage:avatarImage];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.sender isEqualToString:self.sender]) {
        return nil;
    }
    
//    if (indexPath.item - 1 > 0) {
//        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
//        if ([[previousMessage sender] isEqualToString:message.sender]) {
//            return nil;
//        }
//    }
    
    NSString *res = [FMAMessageBoardUtil userFirstNameFromSenderId:message.sender dataSource:dataSource];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:RGBHEX(0xffffff, 1.f)};
    return [[NSAttributedString alloc] initWithString:res attributes:attributes];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if ([msg.sender isEqualToString:self.sender]) {
        cell.textView.textColor = [UIColor blackColor];
    }
    else {
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
    return cell;
}


// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - JSQMessages collection view flow layout delegate
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    if ([[currentMessage sender] isEqualToString:self.sender]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage sender] isEqualToString:[currentMessage sender]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    [self printLogWith:@"Load earlier messages!"];
}

@end
