//
//  FMARevenueUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/27/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMARevenueUtil.h"
#import "FMAConstants.h"
#import "FMAUtil.h"

@implementation FMARevenueUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMARevenueUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (FMARevenueDataSourceType)dataSourceTypeByTabIndex:(NSInteger)selectedIndex
{
    if (selectedIndex == 0)
    {
        return FMA_REVENUE_DATASOURCE_TYPE_DAY;
    }
    else if (selectedIndex == 1)
    {
        return FMA_REVENUE_DATASOURCE_TYPE_MONTH;
    }
    return FMA_REVENUE_DATASOURCE_TYPE_YEAR;
}

+ (CGFloat)totalSumFromDataSource:(NSArray *)dataSource
{
    CGFloat res = 0.f;
    
    for (NSDictionary *data in dataSource)
    {
        res += [data[kFMRevenueSumKey] floatValue];
    }
    
    return res;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - StartDate and EndDate Functions
+ (void)setDatesForDayMode:(NSMutableDictionary *)data byHour:(NSInteger)hour
{
    NSDate *date = [NSDate date];
    
    data[kFMRevenueStartDate] = [FMAUtil resetDate:date byHour:hour-1 minute:0];
    data[kFMRevenueEndDate]   = [FMAUtil resetDate:date byHour:hour-1 minute:59];
}

+ (void)setDatesForMonthMode:(NSMutableDictionary *)data byDay:(NSInteger)day
{
    NSDate *date = [NSDate date];
    
    data[kFMRevenueStartDate] = [FMAUtil resetDate:date byDay:day hour:0 minute:0];
    data[kFMRevenueEndDate]   = [FMAUtil resetDate:date byDay:day hour:23 minute:59];
}

+ (void)setDatesForYearMode:(NSMutableDictionary *)data byMonth:(NSInteger)month
{
    NSDate *date = [NSDate date];
    
    NSInteger endDay = [FMAUtil endDayOfMonth:month];
    
    data[kFMRevenueStartDate] = [FMAUtil resetDate:date byMonth:month day:1         hour:0  minute:0];
    data[kFMRevenueEndDate]   = [FMAUtil resetDate:date byMonth:month day:endDay    hour:23 minute:59];
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Data Source Init Functions
+ (NSMutableArray *)initDataSourceForYear
{
    [self printLogWith:@"initDataSourceForYear"];
    
    NSMutableArray *res = [NSMutableArray array];
    
    for (int i=1; i<=12; i++)
    {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        
        [data setObject:[NSNumber numberWithInt:i]      forKey:kFMRevenueLabelKey];
        [data setObject:[NSNumber numberWithFloat:0.f]  forKey:kFMRevenueSumKey];
        
        [self setDatesForYearMode:data byMonth:i];
        
        [res addObject:data];
    }
    
    return res;
}

+ (NSMutableArray *)initDataSourceForMonth
{
    [self printLogWith:@"initDataSourceForMonth"];
    
    NSMutableArray *res = [NSMutableArray array];
    
    for (int i=1; i<=[FMAUtil endDayOfMonth:[FMAUtil monthFromDate:[NSDate date]]]; i++)
    {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        
        [data setObject:[NSNumber numberWithInt:i]      forKey:kFMRevenueLabelKey];
        [data setObject:[NSNumber numberWithFloat:0.f]  forKey:kFMRevenueSumKey];
        
        [self setDatesForMonthMode:data byDay:i];
        
        [res addObject:data];
    }
    
    return res;
}

+ (NSMutableArray *)initDataSourceForDay
{
    [self printLogWith:@"initDataSourceForDay"];
    
    NSMutableArray *res = [NSMutableArray array];
    
    for (int i=1; i<=24; i++)
    {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        
        [data setObject:[NSNumber numberWithInt:i]      forKey:kFMRevenueLabelKey];
        [data setObject:[NSNumber numberWithFloat:0.f]  forKey:kFMRevenueSumKey];
        
        [self setDatesForDayMode:data byHour:i];
        
        [res addObject:data];
    }
    
    return res;
}

+ (NSMutableArray *)initDataSourceForType:(FMARevenueDataSourceType)type
{
    NSMutableArray *res;
    
    if (type == FMA_REVENUE_DATASOURCE_TYPE_YEAR)
    {
        res = [self initDataSourceForYear];
    }
    else if (type == FMA_REVENUE_DATASOURCE_TYPE_MONTH)
    {
        res = [self initDataSourceForMonth];
    }
    else if (type == FMA_REVENUE_DATASOURCE_TYPE_DAY)
    {
        res = [self initDataSourceForDay];
    }
    return res;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForGetRevenueGraphData:(NSArray *)dataSource
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:dataSource  forKey:@"revenues"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetRevenueGraphData:(NSArray *)dataSource delegate:(id<FMARevenueUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetRevenueGraphData"];
    
    NSDictionary *params = [self requestParamsForGetRevenueGraphData:dataSource];
    
    [PFCloud callFunctionInBackground:@"getRevenueGraphData"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         else
         {
             [delegate requestGetRevenueGraphDataDidRespondWithRevenues:object];
         }
     }];
}

@end
