//
//  FMALoginVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/18/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMALoginVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMABackgroundSetting.h"

#define SEGID_SIGNUP                    @"SEGID_Signup"
#define SEGID_RESETPASSWORD             @"SEGID_ResetPassword"

@interface FMALoginVC ()

@end

@implementation FMALoginVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMALoginVC) return;
    
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
    
    [FMAThemeManager setPlaceholder:@"Email"    toTextField:self.txtEmail    color:[UIColor whiteColor]];
    [FMAThemeManager setPlaceholder:@"Password" toTextField:self.txtPassword color:[UIColor whiteColor]];
}

- (NSArray *)textControlsForInputAccessoryView
{
    return @[self.txtEmail, self.txtPassword];
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
- (IBAction)onBtnLogin:(id)sender
{
    [self printLogWith:@"onBtnLogin"];
    
    if (![self doValidationProcess])
    {
        return;
    }

    [self doUserLogin];
}

- (IBAction)onBtnFacebook:(id)sender
{
    [self printLogWith:@"onBtnFacebook"];
    
    NSArray *permissions = [FMAUserUtil facebookPersmissions];
    
    [FMAUtil showHUD:self.hud withText:@""];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error)
     {
         if (error)
         {
             [self printLogWith:[error localizedDescription]];
             
             [self.hud hide:YES];
             
             [[FMAUtil generalAlertWithTitle:@""
                                     message:@"Please check your network connection."
                                    delegate:self] show];
         }
         else if (!user)
         {
             [self printLogWith:@"Uh oh. The user cancelled the Facebook login."];
         }
         else if (user.isNew)
         {
             [self printLogWith:@"User signed up and logged in through Facebook!"];
             
             [FMAUserUtil startFacebookRequestMeWithDelegate:self];
         }
         else
         {
             [self printLogWith:@"User logged in through Facebook!"];
             
             if ([FMAUtil isStringEmpty:user[kFMUserFacebookIDKey]])
             {
                 [FMAUserUtil startFacebookRequestMeWithDelegate:self];
             }
             else
             {
                 [self.hud hide:YES];
                 
                 [[FMAUtil appDelegate] setupSceneOnLoggedIn];
             }
         }
     }];
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
    [self onBtnLogin:nil];
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - User Login Functions
- (void)doUserLogin
{
    [self printLogWith:@"doUserLogin"];
    
    [FMAUtil showHUD:self.hud withText:@""];
    
    [PFUser logInWithUsernameInBackground:[_txtEmail.text lowercaseString]
                                 password:_txtPassword.text
                                    block:^(PFUser *user, NSError *error)
     {
         [self.hud hide:YES];
         
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
             
             [[FMAUtil alertByParseError:error delegate:self] show];
         }
         else
         {
             [self printLogWith:@"User logged in successfully."];
             
             [FMAUserUtil connectCurrentUserToInstallation];
             
             [[FMAUtil appDelegate] setupSceneOnLoggedIn];
         }
     }];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FBFacebookUtilDelegate
- (void)facebookRequestMeDidLoadWithResult:(id)result
{
    [self printLogWith:@"facebookRequestMeDidLoadWithResult"];
    
    [_hud hide:YES];
    
    PFUser *user = [PFUser currentUser];
    
    if (user)
    {
        [self performSegueWithIdentifier:SEGID_SIGNUP sender:result];
    }
}

- (void)facebookRequestMeError:(NSError *)error
{
    [self printLogWith:@"facebookRequestMeError"];
    
    [_hud hide:YES];
    
    [self printLogWith:[error localizedDescription]];
    
    if ([PFUser currentUser])
    {
        if ([[error userInfo][@"error"][@"type"] isEqualToString:@"OAuthException"])
        {
            [self printLogWith:@"The Facebook token was invalidated. Logging out."];
        }
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)checkAllFieldsExist
{
    [self printLogWith:@"checkAllFieldsExist"];
    
    NSArray *infoFields = @[@{kFMAValidationPlaceholderKey:@"Email",  kFMAValidationControlKey: self.txtEmail},
                            @{kFMAValidationPlaceholderKey:@"Password",  kFMAValidationControlKey: self.txtPassword},];
    
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
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_SIGNUP])
    {
        FMASignupVC *vc = [FMAUtil vcFromSegue:segue];
        vc.delegate     = self;
    
        if ([[FMAUtil classNameFromObject:sender] isEqualToString:kFMFacebookResultClassNameKey])
        {
            vc.facebookResult = sender;
        }
    }
    
    if ([segue.identifier isEqualToString:SEGID_RESETPASSWORD])
    {
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMASignupVCDelegate
- (void)signupVCDidCancel
{
    [self printLogWith:@"signupVCDidCancel"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signupVCDidCreateAccount
{
    [self printLogWith:@"signupVCDidCreateAccount"];
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        [[FMAUtil appDelegate] setupSceneOnLoggedIn];
    }];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TableViewDelegate Function
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if ([FMAUtil isRetina4])
            return 203.f;
        else
            return 115.f;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
