//
//  FMACreateItemVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/2/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMACreateItemVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "ColorUtils.h"
#import "FMAProductUtil.h"

#define DESCRIPTION_PLACEHOLDER_TEXT        @"Description"

#define SEGID_ITEMBARCODESCAN               @"SEGID_ItemBarcodeScan"

#define PACKAGE_DIMENSIONS_DISPLAY_FORMAT   @"(%.2finx%.2finx%.2fin) (%.2foz)"

@interface FMACreateItemVC ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;

@end

@implementation FMACreateItemVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMACreateItemVC) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self printLogWith:@"initWithCoder"];
    
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
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
}

- (void)viewDidLayoutSubviews
{
    [self printLogWith:@"viewDidLayoutSubviews"];
    [super viewDidLayoutSubviews];
    
    [FMAThemeManager relayoutTableviewForApp:self.tableView];
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

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initTheme];
    [self initImageListView];
    [self initTextFieldsPlaceholder];
    [self setupInputAccessoryViews];
    
    _hud = [FMAUtil initHUDWithView:self.view];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    [self initViewBackground];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameDefault toImageView:_imageviewBackground];
}

- (void)initImageListView
{
    [self printLogWith:@"initImageListView"];
    
    _createItemImageListView.backgroundColor = [UIColor clearColor];
    _createItemImageListView.imageList       = [_delegate createItemVCGetImageList];
}

- (void)initTextFieldsPlaceholder
{
    [self printLogWith:@"initTextFieldsPlaceholder"];
    
    [FMAThemeManager setPlaceholder:@"Title"    toTextField:_txtTitle    color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"Price"    toTextField:_txtPrice    color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"N/A"      toTextField:_txtQuantity color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"N/A"      toTextField:_txtBarcode  color:[UIColor whiteColor]];
}

- (NSArray *)textControlsForInputAccessoryView
{
    return @[_txtviewDescription, _txtTitle, _txtPrice, _txtQuantity, _txtBarcode];
}

- (void)setupInputAccessoryViews
{
    [self printLogWith:@"setupInputAccessoryViews"];
    
    [FMAUtil setupInputAccessoryViewWithPrevNextHideButtonsForTextControls:[self textControlsForInputAccessoryView]
                                                                    target:self
                                                 selectorForPreviousButton:@selector(onBtnPrevInInputAccessoryView:)
                                                     selectorForNextButton:@selector(onBtnNextInInputAccessoryView:)
                                                     selectorForDoneButton:nil];
}

- (NSArray *)resizedImageList
{
    [self printLogWith:@"resizedImageList"];
    
    NSArray              *imageList = [_delegate createItemVCGetImageList];
    NSMutableArray *uploadImageList = [[NSMutableArray alloc] init];
    
    for (UIImage *image in imageList)
    {
        UIImage *kk = [FMAProductUtil productImageFromImage:image bySize:kProductImageSize];
        
        [uploadImageList addObject:kk];
    }
    
    return uploadImageList;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TextFields Functions
- (void)onBtnPrevInInputAccessoryView:(id)sender
{
    [self printLogWith:@"onBtnPrevInInputAccessoryView"];
    
    [FMAUtil onBtnPrevInInputAccessoryViewForTextControls:[self textControlsForInputAccessoryView] activeField:activeField];
}
- (void)onBtnNextInInputAccessoryView:(id)sender
{
    [self printLogWith:@"onBtnNextInInputAccessoryView"];
    
    [FMAUtil onBtnNextInInputAccessoryViewForTextControls:[self textControlsForInputAccessoryView] activeField:activeField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    activeField = textField;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    [self onBtnCreate:nil];
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    activeField = textView;
    
    if ([_txtviewDescription.text isEqualToString:DESCRIPTION_PLACEHOLDER_TEXT])
    {
        _txtviewDescription.text = @"";
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([FMAUtil isStringEmpty:_txtviewDescription.text])
    {
        _txtviewDescription.text = DESCRIPTION_PLACEHOLDER_TEXT;
    }
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnCreate:(id)sender
{
    [self printLogWith:@"onBtnCreate"];
    
    if (![self doValidationProcess])
    {
        return;
    }
    
    [self doCreateProduct];
}

- (IBAction)onBtnChooseCategory:(id)sender
{
    [self printLogWith:@"onBtnChooseCategory"];
    
    _chooseCategoryPO = [FMAUtil showPOFromSender:[FMAUtil barButtonItemFromView:sender]
                                    contentVC_SBID:SBID_FMACHOOSECATEGORY_VC
                                 contentVCDelegate:self
                                 popOverVCDelegate:self
                                     contentVCRect:kChooseCategoryPORect
                                     fromBarButton:YES];
    
    FMAChooseCategoryVC *vc = (FMAChooseCategoryVC *)_chooseCategoryPO.contentViewController;
    vc.category             = _category;
}

- (IBAction)onBtnChooseColor:(id)sender
{
    [self printLogWith:@"onBtnChooseColor"];
    
    _chooseColorPO = [FMAUtil showPOFromSender:[FMAUtil barButtonItemFromView:sender]
                                   contentVC_SBID:SBID_FMACHOOSECOLOR_VC
                                contentVCDelegate:self
                                popOverVCDelegate:self
                                    contentVCRect:kChooseColorPORect
                                    fromBarButton:YES];
    
    FMAChooseColorVC *vc = (FMAChooseColorVC *)_chooseColorPO.contentViewController;
    vc.color             = _color;
}

- (IBAction)onBtnModes:(id)sender
{
    [self printLogWith:@"onBtnModes"];
    
    [sender setSelected:![sender isSelected]];
}

- (IBAction)onBtnPackageDimensions:(id)sender
{
    [self printLogWith:@"onBtnPackageDimensions"];
    
    _editPackageDimensionsPO = [FMAUtil showPOFromSender:[FMAUtil barButtonItemFromView:sender]
                                contentVC_SBID:SBID_FMAEDITPACKAGEDIMENSIONS_VC
                             contentVCDelegate:self
                             popOverVCDelegate:self
                                 contentVCRect:kEditPackageDimensionsPORect
                                 fromBarButton:YES];
    
    FMAEditPackageDimensionsVC *vc = (FMAEditPackageDimensionsVC *)_editPackageDimensionsPO.contentViewController;
    
    vc.shippingRate = _shippingRate;
    vc.width        = _width;
    vc.height       = _height;
    vc.length       = _length;
    vc.weight       = _weight;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_ITEMBARCODESCAN])
    {
        FMAItemBarcodeScanVC *vc = [FMAUtil vcFromSegue:segue];
        vc.delegate         = self;
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAItemBarcodeScanVCDelegate
- (void)itemBarcodeScanVCDidScanCode:(NSString *)scannedCode onCodeType:(NSString *)codeType
{
    [self printLogWith:@"itemBarcodeScanVCDidScanCode"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    _txtBarcode.text = scannedCode;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAEditPackageDimensionsVCDelegate
- (void)editPackageDimensionsVCDidCancel
{
    [self printLogWith:@"editPackageDimensionsVCDidCancel"];
    
    [_editPackageDimensionsPO dismissPopoverAnimated:YES];
}

- (void)editPackageDimensionsVC:(FMAEditPackageDimensionsVC *)controller
            didEditShippingRate:(CGFloat)shippingRate width:(CGFloat)width height:(CGFloat)height
                         length:(CGFloat)length weight:(CGFloat)weight
{
    [self printLogWith:@"editPackageDimensionsVC: didEditShippingRate"];
    
    _shippingRate   = shippingRate;
    _width          = width;
    _height         = height;
    _length         = length;
    _weight         = weight;
    
    _labelPackageDimensions.text = [NSString stringWithFormat:PACKAGE_DIMENSIONS_DISPLAY_FORMAT,
                                    _length, _width, _height, _weight];
    
    [_editPackageDimensionsPO dismissPopoverAnimated:YES];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAChooseColorVCDelegate
- (void)chooseColorVCDidCancel
{
    [self printLogWith:@"chooseColorVCDidCancel"];
    
    [_chooseColorPO dismissPopoverAnimated:YES];
}

- (void)chooseCategoryVC:(FMAChooseColorVC *)controller didSelectColor:(PFObject *)color
{
    [self printLogWith:@"chooseCategoryVC didSelectColor"];
    
    _color = color;
    
    _labelColorTitle.text         = color[kFMColorTitleKey];
    _btnColorBack.backgroundColor = [UIColor colorWithString:color[kFMColorValueKey]];
    
    [_chooseColorPO dismissPopoverAnimated:YES];
}
// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAChooseCategoryVCDelegate
- (void)chooseCategoryVCDidCancel
{
    [self printLogWith:@"chooseCategoryVCDidCancel"];
    
    [_chooseCategoryPO dismissPopoverAnimated:YES];
}

- (void)chooseCategoryVC:(FMAChooseCategoryVC *)controller didSelectCategory:(PFObject *)category
{
    [self printLogWith:@"chooseCategoryVC didSelectCategory"];
    
    _category = category;
    
    _labelCategory.text = category[kFMCategoryNameKey];
    
    [_chooseCategoryPO dismissPopoverAnimated:YES];
}

// ------------------------------------------------------------------------------------------------------------------------
#pragma mark - WYPopoverControllerDelegate Functions
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)popoverController
{
    [self printLogWith:@"popoverControllerShouldDismissPopover"];
    return YES;
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
{
    [self printLogWith:@"popoverControllerShouldIgnoreKeyboardBounds"];
    
    if (popoverController == _editPackageDimensionsPO)
    {
        return NO;
    }
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Create New Product Functions
- (PFObject *)uploadProduct
{
    [self printLogWith:@"uploadProduct"];
    
    PFObject *product = [PFObject objectWithClassName:kFMProductClassKey];
    
    product[kFMProductCategoryKey]  = _category;
    product[kFMProductTitleKey]     = _txtTitle.text;
    product[kFMProductPriceKey]     = [NSNumber numberWithFloat:[_txtPrice.text floatValue]];
    product[kFMProductQuantityKey]  = [NSNumber numberWithInteger:[_txtQuantity.text integerValue]];
    product[kFMProductStatusKey]    = [NSNumber numberWithBool:_switchStatus.on];
    product[kFMProductShippingRate] = [NSNumber numberWithFloat:_shippingRate];
    product[kFMProductWidthKey]     = [NSNumber numberWithFloat:_width];
    product[kFMProductHeightKey]    = [NSNumber numberWithFloat:_height];
    product[kFMProductLengthKey]    = [NSNumber numberWithFloat:_length];
    product[kFMProductWeightKey]    = [NSNumber numberWithFloat:_weight];
    
    if ([FMAUtil isObjectNotEmpty:_color])
    {
        product[kFMProductColorKey] = _color;
    }
    
    if ([FMAUtil isStringNotEmpty:_txtviewDescription.text] &&
        ![_txtviewDescription.text isEqualToString:DESCRIPTION_PLACEHOLDER_TEXT])
    {
        product[kFMProductDescriptionKey] = _txtviewDescription.text;
    }
    
    if ([FMAUtil isStringNotEmpty:_txtBarcode.text])
    {
        product[kFMProductBarcodeKey] = _txtBarcode.text;
    }
    
    return product;
}

- (void)doCreateProduct
{
    [self printLogWith:@"doCreateProduct"];
    
    [FMAUtil showHUD:self.hud withText:@""];
    
    PFObject *product = [self uploadProduct];
    
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [self.hud hide:YES];
        
        if (error)
        {
            [self createRequestDidFailWithError:error];
        }
        else
        {
            [self createRequestSucceedWithProduct:product];
        }
    }];
}

- (void)createRequestDidFailWithError:(NSError *)error
{
    [self printLogWith:@"createRequestDidFailWithError"];
    [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
    
    [[FMAUtil alertByParseError:error delegate:self] show];
}

- (void)createRequestSucceedWithProduct:(PFObject *)product
{
    [self printLogWith:@"createRequestSucceedWithProduct"];
    
    [FMAUtil hideHUD:_hud withText:@""];
    
    NSArray *imageList = [self resizedImageList];
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    

    int i = 0;
    for (UIImage *image in imageList)
    {
        NSString *filename  = [NSString stringWithFormat:@"image%d", i];
        NSData *data        = UIImagePNGRepresentation(image);
        
        PFFile *file        = [PFFile fileWithName:filename data:data];
        
        [product addObject:file forKey:kFMProductImagesKey];
        
        i++;
    }
    
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
        }
        else
        {
            [self printLogWith:@"- All images uploaded successfully."];
            [[NSNotificationCenter defaultCenter] postNotificationName:FMACreateItemVCDidUploadProductImagesNotification object:product];
        }
        
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    [_delegate createItemVC:self didCreateProduct:product];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)checkAllFieldsExist
{
    [self printLogWith:@"checkAllFieldsExist"];
    
    NSArray *infoFields = @[@{kFMAValidationPlaceholderKey:@"Title",  kFMAValidationControlKey: _txtTitle},
                            @{kFMAValidationPlaceholderKey:@"Price",  kFMAValidationControlKey: _txtPrice},
                            @{kFMAValidationPlaceholderKey:@"N/A",    kFMAValidationControlKey: _txtQuantity},];
    
    return [FMAUtil checkAllFieldsExist:infoFields];
}

- (BOOL)doValidationProcess
{
    [self printLogWith:@"doValidationProcess"];
    
    if ([[_delegate createItemVCGetImageList] count] == 0)
    {
        [[FMAUtil generalAlertWithTitle:nil message:@"There sould be one image at least for a product." delegate:self] show];
        return NO;
    }
    
    if ([FMAUtil isObjectEmpty:_category])
    {
        [[FMAUtil generalAlertWithTitle:nil message:@"Please choose a category." delegate:self] show];
        return NO;
    }
    
    if (![self checkAllFieldsExist])
    {
        [[FMAUtil generalAlertWithTitle:nil message:ALERT_MSG_FIELDS_EMPTY delegate:self] show];
        return NO;
    }
    
    if ([_txtPrice.text floatValue] == 0.f)
    {
        [[FMAUtil generalAlertWithTitle:nil message:@"Please input a price greater than zero." delegate:self] show];
        return NO;
    }
    
    return YES;
}

@end
