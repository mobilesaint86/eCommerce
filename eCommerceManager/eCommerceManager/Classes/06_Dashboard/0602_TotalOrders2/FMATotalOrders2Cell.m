//
//  FMATotalOrders2Cell.m
//  eCommerceManager
//
//  Created by Albert Chen on 10/20/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMATotalOrders2Cell.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"

@implementation FMATotalOrders2Cell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMATotalOrders2Cell) return;
    
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
    
    _labelDate.text             = [FMAUtil stringFromDate:order.createdAt WithFormat:@"MM/dd/yy"];
    _labelNumberOfOrders.text   = [NSString stringWithFormat:@"%ld Items", (unsigned long)[order[kFMOrderProductsKey] count]];
    _labelTotalPrice.text       = [NSString stringWithFormat:@"$%.2f", [order[kFMOrderTotalPriceKey] floatValue]];
}

- (void)initTheme
{
}

@end
