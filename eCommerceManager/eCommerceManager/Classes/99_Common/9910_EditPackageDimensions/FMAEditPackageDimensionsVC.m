//
//  FMAEditPackageDimensionsVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/3/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAEditPackageDimensionsVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"

@interface FMAEditPackageDimensionsVC ()

@end

@implementation FMAEditPackageDimensionsVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAEditPackageDimensionsVC) return;
    
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
    
    self.view.backgroundColor           = [UIColor clearColor];
    
    [self initTextFieldsPlaceholder];
    [self setupInputAccessoryViews];
    
    [_scrollview setContentSize:_scrollview.frame.size];
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    _txtShippingPrice.text  = [NSString stringWithFormat:@"%.2f", _shippingRate];
    _txtWidth.text          = [NSString stringWithFormat:@"%.2f", _width];
    _txtHeight.text         = [NSString stringWithFormat:@"%.2f", _height];
    _txtLength.text         = [NSString stringWithFormat:@"%.2f", _length];
    _txtWeight.text         = [NSString stringWithFormat:@"%.2f", _length];
}

- (NSArray *)textControlsForInputAccessoryView
{
    return @[self.txtShippingPrice, self.txtLength, self.txtWidth, self.txtHeight, self.txtWeight];
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

- (void)initTextFieldsPlaceholder
{
    [self printLogWith:@"initTextFieldsPlaceholder"];
    
    [FMAThemeManager setPlaceholder:@"Shipping Price"   toTextField:_txtShippingPrice   color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"Length"           toTextField:_txtLength          color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"Width"            toTextField:_txtWidth           color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"Height"           toTextField:_txtHeight          color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"Weight"           toTextField:_txtWeight          color:[UIColor whiteColor]];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnDone:(id)sender
{
    [self printLogWith:@"onBtnDone"];
    
    [_delegate editPackageDimensionsVC:self
                   didEditShippingRate:[_txtShippingPrice.text floatValue]
                                 width:[_txtWidth.text floatValue]
                                height:[_txtHeight.text floatValue]
                                length:[_txtLength.text floatValue]
                                weight:[_txtWeight.text floatValue]];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![FMAUtil checkAndFormatDecimalNumberField:textField
                     shouldChangeCharactersInRange:range
                                 replacementString:string])
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    [self onBtnDone:nil];
    
    return YES;
}

@end
