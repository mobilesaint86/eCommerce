//
//  FMAAddBankVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/29/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAAddBankVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "Stripe.h"
#import "FMAERegisterUtil.h"
#import "FMABackgroundSetting.h"

@interface FMAAddBankVC ()

@end

@implementation FMAAddBankVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAAddBankVC) return;
    
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
    
    [self initViewBackground];
    
    [self setupInputAccessoryViews];
    
    [self initTextFieldsPlaceholder];
    
    _hud = [FMAUtil initHUDWithView:self.view];
}

- (NSArray *)textControlsForInputAccessoryView
{
    return @[_txtRoutingNumber, _txtAccountNumber, _txtConfirmAccountNumber];
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

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:_backgroundName toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:_backgroundName delegate:self];
}

- (void)initTextFieldsPlaceholder
{
    [self printLogWith:@"initTextFieldsPlaceholder"];
    
    [FMAThemeManager setPlaceholder:@"Routing number"         toTextField:_txtRoutingNumber         color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"Account number"         toTextField:_txtAccountNumber         color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"Confirm account number" toTextField:_txtConfirmAccountNumber  color:[UIColor whiteColor]];
}

- (void)emptyFields
{
    [self printLogWith:@"emptyFields"];
    
    _txtRoutingNumber.text        = @"";
    _txtAccountNumber.text        = @"";
    _txtConfirmAccountNumber.text = @"";
    
    [_txtRoutingNumber becomeFirstResponder];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMAThemeManager setBackgroundImageForName:_backgroundName toImageView:_imageviewBackground];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnSave:(id)sender
{
    [self printLogWith:@"onBtnSave"];
    
    if ([self doValidationProcess])
    {
        [self doCreateToken];
    }
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
    
    [self onBtnSave:nil];
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TableViewDelegate Functions
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"tableView: didSelectRowAtIndexPath"];
    
    if (indexPath.row == 2)
    {
        [_txtRoutingNumber becomeFirstResponder];
    }
    else if (indexPath.row == 3)
    {
        [_txtAccountNumber becomeFirstResponder];
    }
    else if (indexPath.row == 4)
    {
        [_txtConfirmAccountNumber becomeFirstResponder];
    }
    else if (indexPath.row == 6)
    {
        [self onBtnSave:nil];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)checkAllFieldsExist
{
    [self printLogWith:@"checkAllFieldsExist"];
    
    NSArray *infoFields = @[@{kFMAValidationPlaceholderKey:@"Routing number",        kFMAValidationControlKey: _txtRoutingNumber},
                            @{kFMAValidationPlaceholderKey:@"Account number",        kFMAValidationControlKey: _txtAccountNumber},
                            @{kFMAValidationPlaceholderKey:@"Confirm account number",kFMAValidationControlKey: _txtConfirmAccountNumber},];
    
    return [FMAUtil checkAllFieldsExist:infoFields];
}

- (BOOL)doValidationProcess
{
    [self printLogWith:@"doValidationProcess"];
    
    if (![self checkAllFieldsExist])
    {
        [[FMAUtil generalAlertWithTitle:nil message:ALERT_MSG_FIELDS_EMPTY delegate:self] show];
        return NO;
    }
    
    if (![self.txtAccountNumber.text isEqualToString:self.txtConfirmAccountNumber.text])
    {
        [[FMAUtil generalAlertWithTitle:nil
                                message:@"Please make sure that you have typed for the Accounting Number and Confirm Accounting Number fields correctly." delegate:nil] show];
        return NO;
    }
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Bank Account Functions
- (FMABank *)bank
{
    FMABank *bank    = [[FMABank alloc] init];
    
    bank.routingNumber = self.txtRoutingNumber.text;
    bank.accountNumber = self.txtAccountNumber.text;
    
    return bank;
}

- (void)doCreateToken
{
    [self printLogWith:@"doCreateToken"];
    
    [FMAUtil showHUD:self.hud withText:@"Validating..."];
    
    FMABank *bank = [self bank];
    
    [Stripe createTokenWithBank:bank
                 publishableKey:[FMAUtil stripePublishableKey]
                     completion:^(STPToken *token, NSError *error)
     {
         [self.hud hide:YES];
         if (error)
         {
             [[FMAUtil generalAlertWithTitle:ALERT_TITLE_ERROR message:[error localizedDescription] delegate:nil] show];
         }
         else
         {
             [self doSaveWithToken:token];
         }
     }];
}

- (void)doSaveWithToken:(STPToken *)token
{
    [self printLogWith:@"doSaveWithToken"];
    
    FMABank *bank = token.bank;
    
    bank.routingNumber = self.txtRoutingNumber.text;
    bank.accountNumber = self.txtAccountNumber.text;
    
    [FMAERegisterUtil storeBank:bank];
    
    [self emptyFields];
    
    [self.delegate addBankVC:self didSaveBank:bank];
}

@end
