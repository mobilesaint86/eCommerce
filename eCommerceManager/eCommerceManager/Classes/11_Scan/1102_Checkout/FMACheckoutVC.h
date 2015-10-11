//
//  FMACheckoutVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/4/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardIO.h"
#import "PKCard.h"
#import "MBProgressHUD.h"
#import "FMACheckoutProductCell.h"
#import "FMABackgroundUtil.h"

@class FMACheckoutVC;
// ----------------------------------------------------------------------------------------
// FMACheckoutVCDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMACheckoutVCDelegate <NSObject>

- (void)checkoutVCDidCancel;
- (void)checkoutVCDidSucceed;

@end

// ----------------------------------------------------------------------------------------
// FMACheckoutVC Class
// ----------------------------------------------------------------------------------------
@interface FMACheckoutVC : UITableViewController<FMACheckoutProductCellDelegate, CardIOPaymentViewControllerDelegate, FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;
@property (strong, 	nonatomic)      NSString    *backgroundName;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic)      id<FMACheckoutVCDelegate> delegate;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      MBProgressHUD  *hud;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      NSMutableArray  *cart;
@property (strong,  nonatomic)      PKCard          *pk_card;

@property (strong,  nonatomic)      UILabel         *labelSubTotal;
@property (strong,  nonatomic)      UILabel         *labelShipping;
@property (strong,  nonatomic)      UILabel         *labelTax;
@property (strong,  nonatomic)      UILabel         *labelGrandTotal;

@end
