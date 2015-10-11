//
//  FMAEmployeesUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/23/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAEmployeesUtil.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"

@implementation FMAEmployeesUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAEmployeesUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForGetEmployeesInEmployeesPageWithFilterParams:(NSInteger)skip
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[NSNumber numberWithInteger:skip]                 forKey:@"skip"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetEmployeesInEmployeesPageWithFilterParams:(NSInteger)skip
                                                  delegate:(id<FMAEmployeesUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetEmployeesInMessageEmployeesPageWithFilterParams"];
    
    NSDictionary *params = [self requestParamsForGetEmployeesInEmployeesPageWithFilterParams:skip];
    
    [PFCloud callFunctionInBackground:@"getEmployeesInEmployeesPageWithFilterParams"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetEmployeesInEmployeesPageWithFilterParamsDidRespondWithEmployees:object];
     }];
}

@end
