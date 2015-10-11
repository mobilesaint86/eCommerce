//
//  FMAScanVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/4/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAScanVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMABackgroundSetting.h"

#define SEGID_CHECKOUT              @"SEGID_CheckOut"

@interface FMAScanVC ()

@end

@implementation FMAScanVC
{
    NSMutableArray *cart;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAScanVC) return;
    
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
//    [self setupTestModel];
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
    
    [self updateLabelsOfItemsCountAndTotalPrice];
    
    _hud = [FMAUtil initHUDWithView:self.view];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    [self initViewBackground];
    [self initNavigationBar];
    [self initTopBar];
    [self initBottomBar];
    [self initScannerView];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameSettings delegate:self];
}

- (void)initNavigationBar
{
    [self printLogWith:@"initNavigationBar"];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)initTopBar
{
    [self printLogWith:@"initTopBar"];
    
    _viewTopBar.backgroundColor = [UIColor clearColor];
    
    [FMAThemeManager setBorderToView:_viewTop1 width:1.f Color:[UIColor lightGrayColor]];
    [FMAThemeManager setBorderToView:_viewTop2 width:1.f Color:[UIColor lightGrayColor]];
}

- (void)initBottomBar
{
    [self printLogWith:@"initBottomBar"];
    
    _viewBottomBar.backgroundColor = [UIColor clearColor];
    
    [FMAThemeManager makeCircleWithView:_btnScan borderColor:[UIColor lightGrayColor] borderWidth:1.f];
}

- (void)initScannerView
{
    [self printLogWith:@"initScannerView"];
    
    [_scannerView setVerboseLogging:YES];
    [_scannerView setAnimateScanner:YES];
    [_scannerView setDisplayCodeOutline:YES];
    
    [_scannerView startCaptureSession];
    [_btnScan setSelected:YES];
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    if ([FMAUtil isObjectEmpty:cart])
    {
        cart = [NSMutableArray array];
    }
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

// -------------------------------------------------------------------------------------------------------------------------
- (void)setupTestModel
{
    [self printLogWith:@"setupTestModel"];
    
    NSArray *dataSource = @[@"1PMC914LL/B", @"9780393301588", @"9000303", @"0705487181418", @"6901028137126"];
    
    for (NSString *barcode in dataSource)
    {
        [FMAScanUtil requestGetProductByBarcode:barcode delegate:self];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnCancel:(id)sender
{
    [self printLogWith:@"onBtnCancel"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnCheckOut:(id)sender
{
    [self printLogWith:@"onBtnCheckOut"];
}

- (IBAction)onBtnScan:(id)sender
{
    [self printLogWith:@"onBtnScan"];
    
    if ([_scannerView isScanSessionInProgress])
    {
        [_scannerView stopScanSession];
        [_btnScan setSelected:NO];
    } else
    {
        [_scannerView startScanSession];
        [_btnScan setSelected:YES];
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_CHECKOUT])
    {
        FMACheckoutVC *vc = [FMAUtil vcFromSegue:segue];
        
        vc.delegate = self;
        vc.cart     = cart;
        
        vc.backgroundName = kFMBackgroundNameSettings;
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMACheckoutVCDelegate
- (void)checkoutVCDidCancel
{
    [self printLogWith:@"checkoutVCDidCancel"];
    
    [self updateLabelsOfItemsCountAndTotalPrice];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkoutVCDidSucceed
{
    [self printLogWith:@"checkoutVCDidSucceed"];
    
    [FMAUtil showHUD:_hud withText:@""];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [FMAUtil hideHUD:_hud withText:@"Successfully Checked Out!"];
        
        [cart removeAllObjects];
        [self updateLabelsOfItemsCountAndTotalPrice];
    }];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - RMScannerViewDelegate
- (void)didScanCode:(NSString *)scannedCode onCodeType:(NSString *)codeType
{
    [self printLogWith:@"Scanner-didScanCode"];
    
    [FMAScanUtil requestGetProductByBarcode:scannedCode delegate:self];

    dispatch_async(dispatch_get_main_queue(), ^{
            [_btnScan setSelected:NO];
    });
}

- (void)errorGeneratingCaptureSession:(NSError *)error
{
    [self printLogWith:@"Scanner-errorGeneratingCaptureSession"];
    
    [_scannerView stopCaptureSession];
    
    [[FMAUtil generalAlertWithTitle:@"Unsupported Device"
                            message:@"This device does not have a camera. Run this app on an iOS device that has a camera."
                           delegate:self] show];
    
    _statusText.text = @"Unsupported Device";
    
    [_btnScan setTitle:@"Scan" forState:UIControlStateNormal];
}

- (void)errorAcquiringDeviceHardwareLock:(NSError *)error
{
    [self printLogWith:@"Scanner-errorAcquiringDeviceHardwareLock"];
    
    [[FMAUtil generalAlertWithTitle:@"Focus Unavailable"
                            message:@"Tap to focus is currently unavailable. Try again in a little while."
                           delegate:nil] show];
}

- (BOOL)shouldEndSessionAfterFirstSuccessfulScan
{
    return YES;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAScanUtilDelegate
- (void)updateLabelsOfItemsCountAndTotalPrice
{
    [self printLogWith:@"updateLabelsOfItemsCountAndTotalPrice"];
    
    _labelItemsCount.text = [NSString stringWithFormat:@"%ld", (long)[FMAScanUtil itemsCountFromCart:cart]];
    _labelTotalPrice.text = [NSString stringWithFormat:@"%.2f", [FMAScanUtil totalPriceFromCart:cart]];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAScanUtilDelegate
- (void)requestGetProductByBarcodeDidRespondWithProduct:(id)product
{
    [self printLogWith:@"requestGetProductByBarcodeDidRespondWithProduct"];
    if ([FMAUtil isObjectEmpty:product]) return;
    
    [FMAScanUtil addProduct:product toCart:cart];
    
    [self updateLabelsOfItemsCountAndTotalPrice];
}

@end
