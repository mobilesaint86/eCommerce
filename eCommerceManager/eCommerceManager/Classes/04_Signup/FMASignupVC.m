//
//  FMASignupVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/21/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMASignupVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMAUserUtil.h"
#import "FMABackgroundSetting.h"

@interface FMASignupVC ()

@end

@implementation FMASignupVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMASignupVC) return;
    
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
    
    [self initTheme];
    [self setupInputAccessoryViews];
    [self initTextFieldsPlaceholder];
    [self initContentFromFacebookResult];
    
    _hud = [FMAUtil initHUDWithView:self.view];
}

- (NSArray *)textControlsForInputAccessoryView
{
    return @[_txtFirstName, _txtLastName, _txtEmail, _txtPhoneNumber, self.txtPassword];
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

- (void)initTheme
{
    [self printLogWith:@"initTheme"];

    [self initViewBackground];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameLogin toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameLogin delegate:self];
}

- (void)initTextFieldsPlaceholder
{
    [self printLogWith:@"initTextFieldsPlaceholder"];
    
    [FMAThemeManager setPlaceholder:@"First Name"       toTextField:_txtFirstName   color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"Last Name"        toTextField:_txtLastName    color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"Email Address"    toTextField:_txtEmail       color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"Phone Number"     toTextField:_txtPhoneNumber color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"Password"         toTextField:_txtPassword    color:[UIColor whiteColor]];
}

- (void)initContentFromFacebookResult
{
    [self printLogWith:@"initContentFromFacebookResult"];
    
    if ([FMAUtil isObjectEmpty:self.facebookResult]) return;
    
    _facebookId         = _facebookResult[kFMFacebookResultIDKey];
    _txtFirstName.text  = _facebookResult[kFMFacebookResultFirstNameKey];
    _txtLastName.text   = _facebookResult[kFMFacebookResultLastNameKey];
    _txtEmail.text      = _facebookResult[kFMFacebookResultEmailKey];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameLogin toImageView:_imageviewBackground];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self.delegate signupVCDidCancel];
}

- (IBAction)onBtnRegister:(id)sender
{
    [self printLogWith:@"onBtnRegister"];

    if ([self doValidationProcess])
    {
        [self doRegister];
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
    
    [self onBtnRegister:nil];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.txtPhoneNumber])
    {
        if (![FMAUtil checkAndFormatPhoneNumberField:textField
                       shouldChangeCharactersInRange:range
                                   replacementString:string])
        {
            return NO;
        }
    }
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TableViewDelegate Functions
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"tableView: didSelectRowAtIndexPath"];
    
    if (indexPath.row == 1)
    {
        [_txtFirstName becomeFirstResponder];
    }
    else if (indexPath.row == 2)
    {
        [_txtEmail becomeFirstResponder];
    }
    else if (indexPath.row == 3)
    {
        [_txtPhoneNumber becomeFirstResponder];
    }
    else if (indexPath.row == 4)
    {
        [_txtPassword becomeFirstResponder];
    }
    else if (indexPath.row == 6)
    {
        [self onBtnRegister:nil];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Registration Functions
- (void)doRegister
{
    [self printLogWith:@"doRegister"];
    
    [FMAUtil showHUD:self.hud withText:@""];
    
    PFUser *user;
    
    if ([FMAUtil isObjectEmpty:self.facebookId])
    {
        user = [[PFUser alloc] init];
    }
    else
    {
        user = [PFUser currentUser];
    }
    
    user[kFMUserUsernameKey]    = [_txtEmail.text lowercaseString];
    user[kFMUserEmailKey]       = [_txtEmail.text lowercaseString];
    user[kFMUserPhoneNumberKey] = _txtPhoneNumber.text;
    user[kFMUserFirstNameKey]   = _txtFirstName.text;
    user[kFMUserLastNameKey]    = _txtLastName.text;
    user[kFMUserRoleKey]        = kFMUserRoleManager;
    
    [user setPassword:self.txtPassword.text];
    
    if ([FMAUtil isObjectNotEmpty:_facebookId])
    {
        user[kFMUserFacebookIDKey] = _facebookId;
    }
    
    if ([FMAUtil isObjectEmpty:self.facebookId])
    {
        [self signupWithPasswordAttachedUser:user];
    }
    else
    {
        [self signupWithoutPasswordUser:user];
    }
}

- (void)signupWithPasswordAttachedUser:(PFUser *)user
{
    [self printLogWith:@"signupWithPasswordAttachedUser"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         [self.hud hide:YES];
         
         if (error)
         {
             [self signupRequestDidFailWithError:error];
             return;
         }
         else
         {
             [self printLogWith:@"User signed up successfully."];
             
             [self signupRequestSucceed];
         }
     }];
}

- (void)signupWithoutPasswordUser:(PFUser *)user
{
    [self printLogWith:@"signupWithoutPasswordUser"];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [self.hud hide:YES];
        
        if (error)
        {
            [self signupRequestDidFailWithError:error];
        }
        else
        {
            [self signupRequestSucceed];
        }
    }];
}

- (void)signupRequestSucceed
{
    [self printLogWith:@"signupRequestSucceed"];
    
    PFUser *user = [PFUser currentUser];
    
    [user saveInBackground];

    [self.delegate signupVCDidCreateAccount];
}

- (void)signupRequestDidFailWithError:(NSError *)error
{
    [self printLogWith:@"signupRequestDidFailWithError"];
    [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
    
    [[FMAUtil alertByParseError:error delegate:self] show];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)checkAllFieldsExist
{
    [self printLogWith:@"checkAllFieldsExist"];
    
    NSArray *infoFields = @[@{kFMAValidationPlaceholderKey:@"First Name",       kFMAValidationControlKey: _txtFirstName},
                            @{kFMAValidationPlaceholderKey:@"Last Name",        kFMAValidationControlKey: _txtLastName},
                            @{kFMAValidationPlaceholderKey:@"Email Address",    kFMAValidationControlKey: _txtEmail},
                            @{kFMAValidationPlaceholderKey:@"Phone Number",     kFMAValidationControlKey: _txtPhoneNumber},
                            @{kFMAValidationPlaceholderKey:@"Password",         kFMAValidationControlKey: _txtPassword},];
    
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
    
    if (![FMAUtil checkValidEmail:self.txtEmail.text])
    {
        [[FMAUtil generalAlertWithTitle:nil message:ALERT_MSG_INVALID_EMAIL delegate:self] show];
        [self.txtEmail becomeFirstResponder];
        
        return NO;
    }
    
    if (![FMAUtil checkValidPhoneNumberLength:self.txtPhoneNumber.text])
    {
        NSString *msg = [NSString stringWithFormat:@"The length of phone number should be %d.", VALID_PHONE_NUMBER_LENGTH];
        [[FMAUtil generalAlertWithTitle:nil message:msg delegate:self] show];
        [self.txtPhoneNumber becomeFirstResponder];
        
        return NO;
    }
    
    int iPasswordValidity = [FMAUtil checkValidPassword:self.txtPassword.text];
    if (iPasswordValidity == SIGNUP_NOVALID_PASSWORD_LENGTH)
    {
        NSString *msg = [NSString stringWithFormat:@"The length of password should be %d or more character.", SIGNUP_VALID_PASSWORD_MINIMUM_LENGTH];
        [[FMAUtil generalAlertWithTitle:nil message:msg delegate:self] show];
        [self.txtPassword becomeFirstResponder];
        
        return NO;
    }
    
    return YES;
}

@end
