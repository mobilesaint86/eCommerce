//
//  FMAAddItemVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/1/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAAddItemVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"

#define CELLID_ADDITEMCELL  @"AddItemCVCell"

#define SEGID_CREATEITEM    @"SEGID_CreateItem"

#define FLASH_MODE_AUTO     0
#define FLASH_MODE_ON       1
#define FLASH_MODE_OFF      2

@interface FMAAddItemVC ()

@end

@implementation FMAAddItemVC
{
    NSIndexPath    *indexPathEditing;
    NSMutableArray *imageList;
    int            iFlashMode;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAAddItemVC) return;
    
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

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initTheme];
    
    [self setupChildPages];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self initViewBackground];
    [self initControlsTheme];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _collectionview.backgroundColor          = [UIColor clearColor];
    _viewCameraViewContainer.backgroundColor = [UIColor clearColor];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameDefault toImageView:_imageviewBackground];
}

- (void)initControlsTheme
{
    [self printLogWith:@"initControls"];
    
    [FMAThemeManager makeCircleWithView:_btnTakePhoto borderColor:[UIColor whiteColor] borderWidth:1.f];
    
    _viewBtnFlash.backgroundColor       = [UIColor clearColor];
    _viewBtnCameraMode.backgroundColor  = [UIColor clearColor];
}

- (void)setupChildPages
{
    [self printLogWith:@"setupChildPages"];
    
    _cameraVC          = [[FMACameraVC alloc] init];
    _cameraVC.delegate = self;
    
    [FMAUtil addChildVC:_cameraVC toParentVC:self inContainerView:_viewCameraViewContainer];
    
    [self initCameraSettings];
}

- (void)initCameraSettings
{
    [self printLogWith:@"initCameraSettings"];
    
    PBJVision *vision = [PBJVision sharedInstance];
    
    vision.cameraDevice = PBJCameraDeviceBack;

    iFlashMode = FLASH_MODE_ON;
    [self setFlashMode:iFlashMode];
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    imageList = [[NSMutableArray alloc] init];
    
//    [imageList addObject:[UIImage imageNamed:@"00_background"]];
//    [imageList addObject:[UIImage imageNamed:@"00_background"]];
//    [imageList addObject:[UIImage imageNamed:@"00_background"]];
}

- (void)setFlashMode:(int)iMode
{
    [self printLogWith:@"setFlashMode"];
    
    PBJVision *vision = [PBJVision sharedInstance];
    
    if (iMode == FLASH_MODE_AUTO)
    {
        vision.flashMode = PBJFlashModeAuto;
        _labelFlashMode.text = @"Auto";
    }
    if (iMode == FLASH_MODE_ON)
    {
        vision.flashMode = PBJFlashModeOn;
        _labelFlashMode.text = @"On";
    }
    if (iMode == FLASH_MODE_OFF)
    {
        vision.flashMode = PBJFlashModeOff;
        _labelFlashMode.text = @"Off";
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnCancel:(id)sender
{
    [self printLogWith:@"onBtnCancel"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnTakePhoto:(id)sender
{
    [self printLogWith:@"onBtnTakePhoto"];
    
    [_cameraVC takePhoto];
}

- (IBAction)onBtnDone:(id)sender
{
    [self printLogWith:@"onBtnDone"];
    
    if ([imageList count] == 0)
    {
        [[FMAUtil generalAlertWithTitle:nil message:@"There sould be one image at least for a product." delegate:self] show];
    }
    else
    {
        [self performSegueWithIdentifier:SEGID_CREATEITEM sender:self];
    }
}

- (IBAction)onBtnFlip:(id)sender
{
    [self printLogWith:@"onBtnFlip"];
    
    PBJVision *vision = [PBJVision sharedInstance];
    vision.cameraDevice = vision.cameraDevice == PBJCameraDeviceBack ? PBJCameraDeviceFront : PBJCameraDeviceBack;
}

- (IBAction)onBtnFlash:(id)sender
{
    [self printLogWith:@"onBtnFlash"];
    
    iFlashMode = (iFlashMode + 1) % 3;
    
    [self setFlashMode:iFlashMode];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_CREATEITEM])
    {
        FMACreateItemVC *vc = [FMAUtil vcFromSegue:segue];
        vc.delegate         = self;
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMACreateItemVCDelegate
- (NSArray *)createItemVCGetImageList
{
    [self printLogWith:@"createItemVCGetImageList"];
    
    return imageList;
}

- (void)createItemVC:(FMACreateItemVC *)controller didCreateProduct:(PFObject *)product
{
    [self printLogWith:@"createItemVC didCreateProduct"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FMAAddItemVCDidCreateProductNotification object:product];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)checkImageListFull
{
    [self printLogWith:@"checkImageListFull"];
    
    if ([imageList count] == MAX_COUNT_ITEM_IMAGES)
    {
        [[FMAUtil generalAlertWithTitle:ALERT_TITLE_WARNING
                                message:@"You have reached to the maximum number of images."
                               delegate:self] show];
        return NO;
    }
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma - FMACameraVCDelegate
- (void)cameraVC:(FMACameraVC *)cameraVC didTakePhoto:(UIImage *)image
{
    [self printLogWith:@"cameraVC didTakePhoto"];
    
    if (![self checkImageListFull])
    {
        return;
    }
    
    [imageList addObject:image];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:imageList.count-1 inSection:0];
    [_collectionview reloadItemsAtIndexPaths:@[indexPath]];
}

- (UIView *)cameraContainerView
{
    return _viewCameraViewContainer;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate
- (UIImage *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [imageList objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MAX_COUNT_ITEM_IMAGES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID_ADDITEMCELL forIndexPath:indexPath];
    
    [FMAThemeManager setBorderToView:cell Width:1.f Color:[UIColor whiteColor] Radius:0.f showShadow:YES];
    
    UIImageView *imageview = (UIImageView *)[cell viewWithTag:105];
    
    if (indexPath.row < [imageList count])
    {
        imageview.image = [self objectAtIndexPath:indexPath];
        
        cell.alpha = 1.f;
    }
    else
    {
        imageview.image      = nil;
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.alpha           = 0.5f;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"collectionView: didSelectItemAtIndexPath:"];
    [self printLogWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    if (indexPath.row < [imageList count])
    {
        [self displayEditorForImage:[self objectAtIndexPath:indexPath]];
        
        indexPathEditing = indexPath;
    }
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Aviary SDK related functions & AFPhotoEditorControllerDelegate
- (void)displayEditorForImage:(UIImage *)imageToEdit
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [AFPhotoEditorController setAPIKey:kAFAviaryAPIKey secret:kAFAviarySecret];
    });
    
    NSArray * toolOrder = @[kAFOrientation, kAFAdjustments, kAFCrop];
    
    [AFPhotoEditorCustomization setToolOrder:toolOrder];
    
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:imageToEdit];
    [editorController setDelegate:self];
    
    [self presentViewController:editorController animated:YES completion:nil];
}

#pragma mark - AFPhotoEditorControllerDelegate
- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    [self printLogWith:@"editor finishedWithImage"];
    
    [imageList replaceObjectAtIndex:indexPathEditing.row withObject:image];
    [_collectionview reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [self printLogWith:@"photoEditorCanceled"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
