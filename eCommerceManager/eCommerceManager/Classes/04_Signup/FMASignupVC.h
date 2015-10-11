//
//  FMASignupVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/21/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "FMABackgroundUtil.h"

@class FMASignupVC;
// ----------------------------------------------------------------------------------
// FMASignupVCDelegate Protocol
// ----------------------------------------------------------------------------------
@protocol FMASignupVCDelegate <NSObject>

- (void)signupVCDidCancel;
- (void)signupVCDidCreateAccount;

@end

// ----------------------------------------------------------------------------------
// FMASignupVC Class
// ----------------------------------------------------------------------------------
@interface FMASignupVC : UITableViewController<UITextFieldDelegate, FMABackgroundUtilDelegate>
{
    UITextField *activeField;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) id<FMASignupVCDelegate> delegate;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)  MBProgressHUD   *hud;
@property (strong,  nonatomic)  NSString        *facebookId;
@property (strong,  nonatomic)  NSDictionary    *facebookResult;

// ----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end
