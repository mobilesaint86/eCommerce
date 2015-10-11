//
//  FMARevenueVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/22/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"
#import "MBProgressHUD.h"
#import "FMATabView.h"
#import "FMARevenueUtil.h"
#import "FMABackgroundUtil.h"

@interface FMARevenueVC : UITableViewController<FMATabViewDelegate, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate, FMARevenueUtilDelegate, FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong,  nonatomic)      MBProgressHUD *hud;

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)     IBOutlet    BEMSimpleLineGraphView *graph;

@property (strong,  nonatomic)                 NSMutableArray *ArrayOfValues;
@property (strong,  nonatomic)                 NSMutableArray *ArrayOfDates;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)     IBOutlet    UIBarButtonItem     *barButtonDate;
@property (weak,    nonatomic)     IBOutlet    FMATabView          *tabView;
@property (weak,    nonatomic)     IBOutlet    UILabel             *labelTotal;

@end
