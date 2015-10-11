//
//  FMALoginVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/18/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "FMASignupVC.h"
#import "FMAUserUtil.h"
#import "FMABackgroundUtil.h"

// ----------------------------------------------------------------------------------
// FMALoginVCDelegate Protocol
// ----------------------------------------------------------------------------------
@protocol FMALoginVCDelegate <NSObject>

- (void)loginVCDidCancel;
- (void)loginVCDidCreateUserAccount;
- (void)loginVCDidLogin;

@end

// ----------------------------------------------------------------------------------
// FMALoginVC Class
// ----------------------------------------------------------------------------------
@interface FMALoginVC : UITableViewController<UITextFieldDelegate, FMASignupVCDelegate, FMAFacebookUtilDelegate, FMABackgroundUtilDelegate>
{
    UITextField *activeField;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMALoginVCDelegate> delegate;

@property (strong, nonatomic) MBProgressHUD *hud;

// ----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end
