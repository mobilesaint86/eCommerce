//
//  FMAEditBackgroundsVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/31/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAEditBackgroundsVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMAEditBackgroundsCVCell.h"
#import "FMABackgroundUtil.h"
#import "FMABackgroundSetting.h"

#define CELLID                      @"EditBackgroundsCell"

@interface FMAEditBackgroundsVC ()

@end

@implementation FMAEditBackgroundsVC
{
    NSMutableArray       *dataSource;
    NSIndexPath          *indexPathEditing;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMACompanyProfileVC) return;
    
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
    [self initDataSource];
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
    
    _hud = [FMAUtil initHUDWithView:self.view];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameSettings delegate:self];
    
    _collectionview.backgroundColor = [UIColor clearColor];
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    [FMAUtil showHUD:_hud withText:@""];
    
    PFQuery *query = [PFQuery queryWithClassName:kFMBackgroundClassKey];
    [query orderByAscending:kFMBackgroundSortOrderKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        [_hud hide:YES];
        
        if (error)
        {
            [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
        }
        else
        {
            dataSource = [[NSMutableArray alloc] initWithArray:objects];
            [_collectionview reloadData];
        }
    }];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnSave:(id)sender
{
    [self printLogWith:@"onBtnSave"];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAImagePickerAMDelegate
- (void)imagePickerAMClickedMenuItemTitle:(NSString *)menuItemTitle
{
    [self printLogWith:@"imagePickerAMClickedMenuItemTitle"];
    
    if ([menuItemTitle isEqualToString:IMAGEPICKER_MENU_ITEM_TAKE_PHOTO])
    {
        [self shouldStartCameraController];
    }
    if ([menuItemTitle isEqualToString:IMAGEPICKER_MENU_ITEM_FROM_CAMERAROLL])
    {
        [self shouldStartPhotoLibraryPickerController];
    }
}

- (BOOL)shouldStartCameraController
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}


- (BOOL)shouldStartPhotoLibraryPickerController
{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO
         && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
               && [[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self printLogWith:@"imagePickerControllerDidCancel"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self printLogWith:@"imagePickerController: didFinishPickingMediaWithInfo"];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImage *image              = [info objectForKey:UIImagePickerControllerEditedImage];
    image                       = [FMAUtil resizeImage:image bySize:kBackgroundImageSize];
    
    FMAEditBackgroundsCVCell *cell = (FMAEditBackgroundsCVCell *)[_collectionview cellForItemAtIndexPath:indexPathEditing];
    cell.imageview.image           = image;
    
    PFObject *data     = [self cellDataAtIndexPath:indexPathEditing];
    
    [[FMABackgroundSetting sharedInstance] saveImage:image withObject:data];
    
    
    if ([kFMBackgroundNameSettings isEqualToString:data[kFMBackgroundNameKey]])
    {
        [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
    }
    
    NSDictionary *noteObject = [FMABackgroundUtil notificationObjectWithImage:image forBackgroundName:data[kFMBackgroundNameKey]];
    [[NSNotificationCenter defaultCenter] postNotificationName:FMABackgroundSettingDidUpdateNotification object:noteObject];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate Functions
- (id)cellDataAtIndexPath:(NSIndexPath *)indexPath
{
    return [dataSource objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMAEditBackgroundsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    
    [cell configureCellWithData:[self cellDataAtIndexPath:indexPath]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"collectionView: didSelectItemAtIndexPath:"];
    [self printLogWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    indexPathEditing = indexPath;
    
    FMAImagePickerAM *actionMenu = [[FMAImagePickerAM alloc] initActionMenu];
    actionMenu.amdelegate        = self;
    
    [actionMenu showActionMenu];
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = (UICollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

@end
