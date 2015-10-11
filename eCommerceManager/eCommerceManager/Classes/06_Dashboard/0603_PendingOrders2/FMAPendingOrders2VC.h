//
//  FMAPendingOrders2VC.h
//  eCommerceManager
//
//  Created by Albert Chen on 10/20/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FMAPendingOrders2Cell.h"
#import "FMAPendingOrdersUtil.h"
#import "FMABackgroundUtil.h"

@interface FMAPendingOrders2VC : UITableViewController<UITableViewDataSource, UITableViewDelegate, FMABackgroundUtilDelegate, FMAPendingOrdersUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)  PFImageView     *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)  MBProgressHUD   *hud;
@property (strong,  nonatomic)  UILabel         *labelEmpty;

@end
