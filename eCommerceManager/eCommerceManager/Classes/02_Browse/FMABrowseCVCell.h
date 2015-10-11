//
//  FMABrowseCVCell.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/20/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FMAData.h"

@class FMABrowseCVCell;
// -----------------------------------------------------------------------------------
// FMABrowseCVCellDelegate Protocol
// -----------------------------------------------------------------------------------
@protocol FMABrowseCVCellDelegate <NSObject>

- (void)browseCVCellDidClickShare:(FMABrowseCVCell *)cell;

@end

// -----------------------------------------------------------------------------------
// FMABrowseCVCell Class
// -----------------------------------------------------------------------------------
@interface FMABrowseCVCell : UICollectionViewCell

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMABrowseCVCellDelegate> delegate;

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UIButton       *btnShare;
@property (weak, nonatomic) IBOutlet UILabel        *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel        *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel        *labelDistance;
@property (weak, nonatomic) IBOutlet UILabel        *labelPostedPeriod;
@property (weak, nonatomic) IBOutlet UILabel        *labelShippingRate;
@property (weak, nonatomic) IBOutlet PFImageView    *imageviewProduct;
@property (weak, nonatomic) IBOutlet UITextView     *textviewTitle;

// -----------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;

@end
