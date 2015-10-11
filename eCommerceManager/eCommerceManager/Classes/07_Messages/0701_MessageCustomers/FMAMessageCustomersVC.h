//
//  FMAMessageCustomersVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/26/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FMAMessageCustomersUtil.h"
#import "FMACustomerMessageVC.h"
#import "FMABackgroundUtil.h"

@interface FMAMessageCustomersVC : UIViewController<UITableViewDataSource, UITableViewDelegate, FMAMessageCustomersUtilDelegate, FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      MBProgressHUD *hud;
@property (strong,  nonatomic)      UILabel       *labelEmpty;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)     IBOutlet    UITableView          *tableview;

@end
