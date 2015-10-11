//
//  FMARevenueUtil.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/27/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FMAData.h"

// -----------------------------------------------------------------------------------------
// FMARevenueUtilDelegate Protocol
// -----------------------------------------------------------------------------------------
@protocol FMARevenueUtilDelegate<NSObject>

- (void)requestGetRevenueGraphDataDidRespondWithRevenues:(NSArray *)revenues;

@end

// -----------------------------------------------------------------------------------------
// FMARevenueUtil Class
// -----------------------------------------------------------------------------------------
@interface FMARevenueUtil : NSObject

// -----------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (FMARevenueDataSourceType)dataSourceTypeByTabIndex:(NSInteger)selectedIndex;
+ (CGFloat)totalSumFromDataSource:(NSArray *)dataSource;

// -----------------------------------------------------------------------------------------
#pragma mark - Data Source Init Functions
+ (NSMutableArray *)initDataSourceForType:(FMARevenueDataSourceType)type;

// -----------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetRevenueGraphData:(NSArray *)dataSource
                          delegate:(id<FMARevenueUtilDelegate>)delegate;

@end
