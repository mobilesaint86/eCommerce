//
//  FMACustomerReviewsCell.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/25/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RatingView.h"

@interface FMACustomerReviewsCell : UITableViewCell<RatingViewDelegate>

// ----------------------------------------------------------------------------------------
@property (strong, nonatomic)          RatingView       *ratingview;
@property (weak,   nonatomic) IBOutlet UILabel          *labelRatingViewBack;
@property (weak,   nonatomic) IBOutlet PFImageView      *imageviewBuyer;
@property (weak,   nonatomic) IBOutlet PFImageView      *imageviewItem;
@property (weak,   nonatomic) IBOutlet UILabel          *labelDate;
@property (weak,   nonatomic) IBOutlet UILabel          *labelCustomerName;
@property (weak,   nonatomic) IBOutlet UILabel          *labelProductTitles;
@property (weak,   nonatomic) IBOutlet UILabel          *labelRatingValue;
@property (weak,   nonatomic) IBOutlet UILabel          *labelComment;

// ----------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;

@end
