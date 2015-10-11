//
//  FMBPreviousOrders2VC.h
//  eCommerceCustomer
//
//  Created by Albert Chen on 10/20/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FMBPreviousOrders2Cell.h"
#import "FMBPreviousOrdersUtil.h"
#import "FMBBackgroundUtil.h"

@interface FMBPreviousOrders2VC : UITableViewController<UITableViewDataSource, UITableViewDelegate, FMBBackgroundUtilDelegate, FMBPreviousOrdersUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)  PFImageView     *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)  MBProgressHUD   *hud;
@property (strong,  nonatomic)  UILabel         *labelEmpty;

@end
