//
//  FMAMessageEmployeesUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/22/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAMessageEmployeesUtil.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"

@implementation FMAMessageEmployeesUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAMessageEmployeesUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)setDistanceLabel:(UILabel *)labelDistance withUser:(PFUser *)other
{
    PFUser *user = [PFUser currentUser];
    
    [PFConfig getConfigInBackgroundWithBlock:^(PFConfig *config, NSError *error) {
        if (error)
        {
            [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
        }
        else
        {
            PFGeoPoint *otherLocation = other[kFMUserLocationKey];
            
            if ([FMAUtil isObjectEmpty:otherLocation]) return;
            
            PFGeoPoint *userLocation = user[kFMUserLocationKey];
            
            if ([FMAUtil isObjectEmpty:userLocation]) return;
            
            CGFloat distance = [userLocation distanceInMilesTo:otherLocation];
            
            labelDistance.text = [NSString stringWithFormat:@"%.1fmi", distance];
        }
    }];
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForGetEmployeesInMessageEmployeesPageWithFilterParams:(NSInteger)skip
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[NSNumber numberWithInteger:skip]                 forKey:@"skip"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetEmployeesInMessageEmployeesPageWithFilterParams:(NSInteger)skip
                                                         delegate:(id<FMAMessageEmployeesUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetEmployeesInMessageEmployeesPageWithFilterParams"];
    
    NSDictionary *params = [self requestParamsForGetEmployeesInMessageEmployeesPageWithFilterParams:skip];
    
    [PFCloud callFunctionInBackground:@"getEmployeesInMessageEmployeesPageWithFilterParams"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetEmployeesInMessageEmployeesPageWithFilterParamsDidRespondWithEmployees:object];
     }];
}

@end
