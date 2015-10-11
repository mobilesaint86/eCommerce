//
//  FMBScannedProductsVC.h
//  eCommerceCustomer
//
//  Created by Albert Chen on 9/24/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBScannedProductsCell.h"
#import "FMBProductsDetailsVC.h"
#import "WYPopoverController.h"
#import "FMBAddToCartVC.h"
#import "FMBBackgroundUtil.h"

@interface FMBScannedProductsVC : UITableViewController<FMBScannedProductsCellDelegate, FMBAddToCartVCDelegate, WYPopoverControllerDelegate, FMBBackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      NSArray         *products;
@property (strong,  nonatomic)      UILabel         *labelEmpty;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic) WYPopoverController       *addToCartPO;

@end
