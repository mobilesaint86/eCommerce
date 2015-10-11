//
//  FMAResetPasswordVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/21/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "FMABackgroundUtil.h"

// ----------------------------------------------------------------------------------
// FMAResetPasswordVC Class
// ----------------------------------------------------------------------------------
@interface FMAResetPasswordVC : UITableViewController<UITextFieldDelegate, FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)          MBProgressHUD   *hud;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UILabel    *labelEmailContainer;
@property (weak,    nonatomic) IBOutlet UIButton   *btnImageEmail;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UITextField *txtEmail;
@property (weak,    nonatomic) IBOutlet UILabel     *labelMsg;
@property (weak,    nonatomic) IBOutlet UIButton    *btnSendRequest;

@end
