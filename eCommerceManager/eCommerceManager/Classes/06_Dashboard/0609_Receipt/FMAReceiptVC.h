//
//  FMAReceiptVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/27/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "RatingView.h"
#import "FMACustomerMessageVC.h"
#import "FMABackgroundUtil.h"

@interface FMAReceiptVC : UIViewController<RatingViewDelegate, FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;
@property (strong, 	nonatomic)      NSString    *backgroundName;

// ----------------------------------------------------------------------------------------
@property (strong, nonatomic)          PFObject         *order;

// ----------------------------------------------------------------------------------------
@property (strong, nonatomic)          RatingView       *ratingview;
@property (weak,   nonatomic) IBOutlet UILabel          *labelRatingViewBack;
@property (weak,   nonatomic) IBOutlet UITextView       *txtviewComment;
@property (weak,   nonatomic) IBOutlet UILabel          *labelTotalPrice;

@end
