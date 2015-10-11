//
//  FMACustomerReviewsCell.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/25/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMACustomerReviewsCell.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMACustomerReviewsUtil.h"

@implementation FMACustomerReviewsCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMACustomerReviewsCell) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
}

- (void)setSelected:(BOOL)selected
{
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data
{
    [self printLogWith:@"configureCellWithData"];
    
    [self initTheme];
    
    PFObject *order = (PFObject *)data;
    
    _ratingview.value       = [order[kFMOrderReviewRateKey] floatValue];
    _labelCustomerName.text = order[kFMOrderCustomerKey][kFMUserFirstNameKey];
    _labelDate.text         = [FMAUtil stringFromDate:order.updatedAt WithFormat:@"MMM dd, yyyy"];
    _labelRatingValue.text  = [NSString stringWithFormat:@"%.2f", [order[kFMOrderReviewRateKey] floatValue]];
    _labelComment.text      = order[kFMOrderReviewCommentKey];    
    [FMACustomerReviewsUtil setProductTitlesFromOrder:order     toLabel:_labelProductTitles];
    [FMACustomerReviewsUtil setFirstProductImageFromOrder:order toImageView:_imageviewItem];
}

- (void)initTheme
{
    [self initRatingView];
    
    [FMAThemeManager makeCircleWithView:_imageviewBuyer
                            borderColor:RGBHEX(0xffffff, 1.f)
                            borderWidth:COMMON_WIDTH_FOR_CIRCLE_BORDER];
    
    [FMAThemeManager setBorderToView:_imageviewItem
                               width:COMMON_WIDTH_FOR_CIRCLE_BORDER
                               Color:[UIColor whiteColor]];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)initRatingView
{
    [self printLogWith:@"initRatingView"];
    
    self.labelRatingViewBack.backgroundColor = [UIColor clearColor];
    
    self.ratingview          = [FMAUtil initRatingViewWithFrame:self.labelRatingViewBack.frame];
    self.ratingview.delegate = self;
    
    [self addSubview:self.ratingview];
    
    self.ratingview.userInteractionEnabled = NO;
}

// ------------------------------------------------------------------------------------------------------------------------
#pragma mark - RatingViewDelegate
- (void)rateChanged:(RatingView *)sender
{
    [self printLogWith:@"rateChanged"];
    [self printLogWith:[NSString stringWithFormat:@"%.2f", sender.value]];
}

@end
