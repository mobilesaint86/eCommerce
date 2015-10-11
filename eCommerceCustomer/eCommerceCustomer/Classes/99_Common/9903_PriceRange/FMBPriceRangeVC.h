//
//  FMBPriceRangeVC.h
//  eCommerceCustomer
//
//  Created by Albert Chen on 9/6/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACVRangeSelector.h"

@class FMBPriceRangeVC;
// ----------------------------------------------------------------------------------------
// FMBPriceRangeVCDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMBPriceRangeVCDelegate <NSObject>

@end

// ----------------------------------------------------------------------------------------
// FMBPriceRangeVC Class
// ----------------------------------------------------------------------------------------
@interface FMBPriceRangeVC : UIViewController

// ----------------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMBPriceRangeVCDelegate> delegate;

// ----------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet ACVRangeSelector *rangesliderPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelMin;
@property (weak, nonatomic) IBOutlet UILabel *labelMax;

@end
