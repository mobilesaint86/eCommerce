//
//  FMAERegisterVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/27/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "FMAERegisterUtil.h"
#import "FMABankListView.h"
#import "FMACardListView.h"
#import "FMAAddBankVC.h"
#import "FMAAddCardVC.h"
#import "REFrostedViewController.h"
#import "FMABackgroundUtil.h"
#import "FMAWithdrawVC.h"

@interface FMAERegisterVC : UIViewController<FMABankListViewDelegate, FMACardListViewDelegate,FMAAddBankVCDelegate, FMAAddCardVCDelegate, FMAERegisterUtilDelegate, FMABackgroundUtilDelegate, FMAWithdrawVCDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------------
@property (strong,  nonatomic)      MBProgressHUD    *hud;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    UIView           *viewBack1;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    PFImageView      *imageviewAvatar;
@property (weak,    nonatomic)      IBOutlet    FMABankListView  *bankListView;
@property (weak,    nonatomic)      IBOutlet    FMACardListView  *cardListView;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    UILabel          *labelTotalBalance;
@property (weak,    nonatomic)      IBOutlet    UILabel          *labelAvailableBalance;
@property (weak,    nonatomic)      IBOutlet    UILabel          *labelName;

@end
