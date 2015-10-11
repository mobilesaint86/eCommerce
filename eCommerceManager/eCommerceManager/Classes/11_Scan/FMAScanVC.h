//
//  FMAScanVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/4/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMScannerView.h"
#import "FMAScanUtil.h"
#import "FMACheckoutVC.h"
#import "MBProgressHUD.h"
#import "FMABackgroundUtil.h"


@interface FMAScanVC : UIViewController<RMScannerViewDelegate, UIAlertViewDelegate, FMAScanUtilDelegate, FMACheckoutVCDelegate, FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic) MBProgressHUD   *hud;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet     UIView          *viewTopBar;
@property (weak,    nonatomic) IBOutlet     UIView          *viewTop1;
@property (weak,    nonatomic) IBOutlet     UIView          *viewTop2;
@property (weak,    nonatomic) IBOutlet     UIView          *viewBottomBar;
@property (strong,  nonatomic) IBOutlet     RMScannerView   *scannerView;
@property (weak,    nonatomic) IBOutlet     UILabel         *statusText;
@property (strong,  nonatomic) IBOutlet     UIButton        *btnScan;

@property (weak,    nonatomic) IBOutlet     UILabel         *labelItemsCount;
@property (weak,    nonatomic) IBOutlet     UILabel         *labelTotalPrice;

@end
