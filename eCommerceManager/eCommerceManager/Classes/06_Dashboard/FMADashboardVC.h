//
//  FMADashboardVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/22/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMADashboardUtil.h"
#import "FMABackgroundUtil.h"

@interface FMADashboardVC : UITableViewController<FMADashboardUtilDelegate, FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UIBarButtonItem     *barButtonDate;
@property (weak,    nonatomic) IBOutlet UILabel             *labelTotalRevenue;
@property (weak,    nonatomic) IBOutlet UILabel             *labelPendingOrders;
@property (weak,    nonatomic) IBOutlet UILabel             *labelTotalOrders;
@property (weak,    nonatomic) IBOutlet UILabel             *labelCustomerReviews;
@property (weak,    nonatomic) IBOutlet UILabel             *labelEmployees;

@end
