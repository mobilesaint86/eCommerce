//
//  FMAPriceRangeVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/20/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACVRangeSelector.h"

@class FMAPriceRangeVC;
// ----------------------------------------------------------------------------------------
// FMAPriceRangeVCDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMAPriceRangeVCDelegate <NSObject>

@end

// ----------------------------------------------------------------------------------------
// FMAPriceRangeVC Class
// ----------------------------------------------------------------------------------------
@interface FMAPriceRangeVC : UIViewController

// ----------------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMAPriceRangeVCDelegate> delegate;

// ----------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet ACVRangeSelector *rangesliderPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelMin;
@property (weak, nonatomic) IBOutlet UILabel *labelMax;

@end
