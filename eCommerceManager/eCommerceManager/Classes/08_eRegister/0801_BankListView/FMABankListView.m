//
//  FMABankListView.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/27/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMABankListView.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMABankListCVCell.h"
#import "FMAERegisterUtil.h"

#define CELLID                              @"BankListCVCell"
#define EMPTY_LABEL_TEXT                    @"No Bank Account(s)"
#define MESSAGE_BANK_DELETE                 @"Are you sure you want to delete this bank account?"
#define TAG_ALERTVIEW_BANK_DELETE           107

@implementation FMABankListView
{
    NSMutableArray  *_bankList;
    NSIndexPath     *_indexPathDeleting;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMABankListView) return;
    
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

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - LifeCycle Functions
- (void)awakeFromNib
{
    [self printLogWith:@"awakeFromNib"];
    [super awakeFromNib];
    
    [self initUI];
    [self initDataSource];
    
    [self layoutEmptyLabel];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    _collectionview.backgroundColor = [UIColor clearColor];
    
    _collectionview.backgroundView  = self.labelEmpty;
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    _bankList = [FMAERegisterUtil bankList];
}

- (void)addBank:(FMABank *)bank
{
    [self printLogWith:@"addBank"];
    
    [_bankList addObject:bank];
    [_collectionview reloadData];
    
    if ([_bankList count] == 1)
    {
        [self layoutEmptyLabel];
    }
}

- (void)deleteBankAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"deleteBankAtIndexPath"];
    
    [_bankList removeObjectAtIndex:indexPath.row];
    [_collectionview reloadData];
    
    [FMAERegisterUtil deleteBankByIndex:indexPath.row];
    
    if ([_bankList count] == 0)
    {
        [self layoutEmptyLabel];
        
        self.bEdit = NO;
    }
}

- (void)layoutEmptyLabel
{
    [self printLogWith:@"layoutEmptyLabel"];
    
    if ([_bankList count] > 0)
    {
        self.labelEmpty.text = @"";
    }
    else
    {
        self.labelEmpty.text = EMPTY_LABEL_TEXT;
    }
}

- (UILabel *)labelEmpty
{
    [self printLogWith:@"emptyLabel"];
    
    if (!_labelEmpty)
    {
        UILabel *label = [[UILabel alloc] init];
        
        CGRect rect = _collectionview.frame;
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

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnAdd:(id)sender
{
    [self printLogWith:@"onBtnAdd"];
    
    [_delegate bankListViewDidClickAddButton];
}

- (IBAction)onBtnTrash:(id)sender
{
    [self printLogWith:@"onBtnTrash"];
    
    self.bEdit = !self.bEdit;
    [_collectionview reloadData];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self printLogWith:@"alertView clickedButtonAtIndex"];
    
    if (buttonIndex == 1)
    {
        if (alertView.tag == TAG_ALERTVIEW_BANK_DELETE)
        {
            [self deleteBankAtIndexPath:_indexPathDeleting];
        }
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate Functions
- (FMABank *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [_bankList objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_bankList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMABankListCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    
    FMABank *bank = [self objectAtIndexPath:indexPath];
    
    [cell configureCellWithData:bank isEditMode:_bEdit];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"collectionView: didSelectItemAtIndexPath:"];
    [self printLogWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    if (self.bEdit)
    {
        UIAlertView *alertView = [FMAUtil okCancelAlertWithTitle:nil message:MESSAGE_BANK_DELETE
                                                        OkTitle:nil CancelTitle:nil delegate:self];
        alertView.tag = TAG_ALERTVIEW_BANK_DELETE;
        [alertView show];
        
        _indexPathDeleting = indexPath;
    }
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

@end
