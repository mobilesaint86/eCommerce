//
//  FMACustomerReviewsVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/25/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FMACustomerReviewsUtil.h"
#import "FMACustomerMessageVC.h"
#import "FMABackgroundUtil.h"

@interface FMACustomerReviewsVC : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, FMACustomerReviewsUtilDelegate, FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      MBProgressHUD *hud;
@property (strong,  nonatomic)      UILabel       *labelEmpty;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)     IBOutlet    UITableView          *tableview;
@property (weak,    nonatomic)     IBOutlet    UISearchBar          *searchBar;

@end
