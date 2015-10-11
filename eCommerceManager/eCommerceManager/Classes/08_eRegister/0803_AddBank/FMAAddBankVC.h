//
//  FMAAddBankVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/29/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "FMABank.h"
#import "FMABackgroundUtil.h"

@class FMAAddBankVC;
// ----------------------------------------------------------------------------------
// FMAAddBankVCDelegate Protocol
// ----------------------------------------------------------------------------------
@protocol FMAAddBankVCDelegate <NSObject>

- (void)addBankVC:(FMAAddBankVC *)controller didSaveBank:(FMABank *)bank;

@end

// ----------------------------------------------------------------------------------
// FMAAddBankVC Class
// ----------------------------------------------------------------------------------
@interface FMAAddBankVC : UITableViewController<UITextFieldDelegate, FMABackgroundUtilDelegate>
{
    UITextField *activeField;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      NSString    *backgroundName;
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) id<FMAAddBankVCDelegate> delegate;
@property (strong,  nonatomic) MBProgressHUD           *hud;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UITextField  *txtRoutingNumber;
@property (weak,    nonatomic) IBOutlet UITextField  *txtAccountNumber;
@property (weak,    nonatomic) IBOutlet UITextField  *txtConfirmAccountNumber;

@end
