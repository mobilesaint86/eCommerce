//
//  FMAItemBarcodeScanVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/15/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAItemBarcodeScanVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"

@interface FMAItemBarcodeScanVC ()

@end

@implementation FMAItemBarcodeScanVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAItemBarcodeScanVC) return;
    
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
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    [self initViewBackground];
    [self initScannerView];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameDefault toImageView:_imageviewBackground];
    
    _viewBack1.backgroundColor      = [UIColor clearColor];
}

- (void)initScannerView
{
    [self printLogWith:@"initScannerView"];
    
    
    [_scannerView setVerboseLogging:YES];
    [_scannerView setAnimateScanner:YES];
    [_scannerView setDisplayCodeOutline:YES];
    
    [_scannerView startCaptureSession];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - RMScannerViewDelegate
- (void)didScanCode:(NSString *)scannedCode onCodeType:(NSString *)codeType
{
    [self printLogWith:@"Scanner-didScanCode"];

    [_delegate itemBarcodeScanVCDidScanCode:scannedCode onCodeType:codeType];
}

- (void)errorGeneratingCaptureSession:(NSError *)error
{
    [self printLogWith:@"Scanner-errorGeneratingCaptureSession"];
    
    [_scannerView stopCaptureSession];
    
    [[FMAUtil generalAlertWithTitle:@"Unsupported Device"
                            message:@"This device does not have a camera. Run this app on an iOS device that has a camera."
                           delegate:self] show];
    
    _statusText.text = @"Unsupported Device";
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

@end
