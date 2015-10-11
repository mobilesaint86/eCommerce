//
//  FMADashboardUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/22/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMADashboardUtil.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"

@implementation FMADashboardUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAEmployeeMessageUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)initDateBarButtonItem:(UIBarButtonItem *)btnItem
{
    [self printLogWith:@"setCurrentDateToLabel"];
    
    NSString *string = [FMAUtil stringFromDate:[NSDate date] WithFormat:@"MMM YYYY"];
    
    [btnItem setTitle:string];
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForGetTotalRevenueInDashboardPageWithParams
{
    NSDate *firstDateOfMonth = [FMAUtil firstDayOfMonthForDate:[NSDate date]];
    NSDate  *lastDateOfMonth = [FMAUtil lastDayOfMonthForDate:[NSDate date]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:firstDateOfMonth  forKey:@"firstDate"];
    [params setObject:lastDateOfMonth   forKey:@"lastDate"];

    return params;
}

+ (NSDictionary *)requestParamsForGetTotalNumberOfReviewsInDashboardPage
{
    NSDate *firstDateOfMonth = [FMAUtil firstDayOfMonthForDate:[NSDate date]];
    NSDate  *lastDateOfMonth = [FMAUtil lastDayOfMonthForDate:[NSDate date]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:firstDateOfMonth  forKey:@"firstDate"];
    [params setObject:lastDateOfMonth   forKey:@"lastDate"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions

// Get the total revenue of this month from a cloud call and set the value to Label
+ (void)requestGetTotalRevenueInDashboardPageWithParams:(UILabel *)label
{
    [self printLogWith:@"requestGetTotalRevenueInDashboardPageWithParams"];
    
    NSDictionary *params = [self requestParamsForGetTotalRevenueInDashboardPageWithParams];
    
    [PFCloud callFunctionInBackground:@"getTotalRevenueInDashboardPageWithParams"
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
             label.text = [NSString stringWithFormat:@"$%.2f", [object floatValue]];
         }
     }];
}

// Get the number of total orders of the current month and set the value to Label
+ (void)requestGetNumberOfTotalOrdersInDashboardPageWithParams:(UILabel *)label
{
    [self printLogWith:@"requestGetNumberOfTotalOrdersInDashboardPageWithParams"];
    
    NSDate *firstDateOfMonth = [FMAUtil firstDayOfMonthForDate:[NSDate date]];
    NSDate  *lastDateOfMonth = [FMAUtil lastDayOfMonthForDate:[NSDate date]];

    PFQuery *query = [PFQuery queryWithClassName:kFMOrderClassKey];
    
    [query whereKey:kPFObjectCreatedAtKey greaterThanOrEqualTo:firstDateOfMonth];
    [query whereKey:kPFObjectCreatedAtKey lessThanOrEqualTo:lastDateOfMonth];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error)
     {
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         else
         {
             label.text = [NSString stringWithFormat:@"%d", number];
         }
     }];
}

// Get the number of pending orders of the current month and set the value to Label
+ (void)requestGetNumberOfPendingOrdersInDashboardPageWithParams:(UILabel *)label
{
    [self printLogWith:@"requestGetNumberOfPendingOrdersInDashboardPageWithParams"];
    
    NSDate *firstDateOfMonth = [FMAUtil firstDayOfMonthForDate:[NSDate date]];
    NSDate  *lastDateOfMonth = [FMAUtil lastDayOfMonthForDate:[NSDate date]];
    
    PFQuery *innerQuery = [PFQuery queryWithClassName:kFMOrderStatusClassKey];
    [innerQuery whereKey:kFMOrderStatusNameKey notEqualTo:kFMOrderStatusNameCompleteValue];
    
    PFQuery *query = [PFQuery queryWithClassName:kFMOrderClassKey];
    
    [query whereKey:kPFObjectCreatedAtKey greaterThanOrEqualTo:firstDateOfMonth];
    [query whereKey:kPFObjectCreatedAtKey lessThanOrEqualTo:lastDateOfMonth];
    [query whereKey:kFMOrderStatusKey matchesQuery:innerQuery];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error)
     {
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         else
         {
             label.text = [NSString stringWithFormat:@"%d", number];
         }
     }];
}

// Get the number of employees and set the value to Label
+ (void)requestGetNumberOfEmployeesInDashboardPageWithParams:(UILabel *)label
{
    [self printLogWith:@"requestGetNumberOfEmployeesInDashboardPage"];
    
    PFQuery *query = [PFUser query];
    
    [query whereKey:kPFObjectObjectIDKey notEqualTo:[PFUser currentUser].objectId];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error)
    {
        if (error)
        {
            [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
        }
        else
        {
            label.text = [NSString stringWithFormat:@"%d", number];
        }
    }];
}

// Get the number of customer reviews and set the value to Label
+ (void)requestGetTotalNumberOfReviewsInDashboardPage:(UILabel *)label
{
    [self printLogWith:@"requestGetTotalNumberOfReviewsInDashboardPage"];
    
    NSDictionary *params = [self requestParamsForGetTotalNumberOfReviewsInDashboardPage];
    
    [PFCloud callFunctionInBackground:@"getTotalNumberOfReviewsInDashboardPage"
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
             label.text = [NSString stringWithFormat:@"%d", [object intValue]];
         }
     }];
}

@end
