//
//  FMATotalOrdersCVCell.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/23/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMATotalOrdersCVCell.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMATotalOrdersUtil.h"
#import "TTTTimeIntervalFormatter.h"

static TTTTimeIntervalFormatter *timeFormatter;

@implementation FMATotalOrdersCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMATotalOrdersCVCell) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
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
    
    [FMATotalOrdersUtil setFirstProductImageFromOrder:order toImageView:_imageview];
    [FMATotalOrdersUtil setProductTitlesFromOrder:order toLabel:_labelProductTitles];
    [FMATotalOrdersUtil setOrderStatusFromOrder:order toLabel:_labelStatus];
    
    _labelTotalPrice.text = [NSString stringWithFormat:@"$%.2f", [order[kFMOrderTotalPriceKey] floatValue]];
    
    if (!timeFormatter)
    {
        timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }
    
    if ([_delegate totalOrdersCVCellCheckViewModeGrid])
    {
        _labelOrderedPeriod.text = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:order.createdAt];
    }
    else
    {
        _labelOrderedPeriod.text = [NSString stringWithFormat:@"ordered: %@",
                                   [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:order.createdAt]];
    }
}

- (void)initTheme
{
    _imageview.contentMode = UIViewContentModeScaleAspectFill;
    _imageview.clipsToBounds = YES;
}

@end
