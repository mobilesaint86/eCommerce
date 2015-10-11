//
//  FMAMessageCustomersUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/26/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAMessageCustomersUtil.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"

@implementation FMAMessageCustomersUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAMessageCustomersUtil) return;
    
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
+ (NSDictionary *)requestParamsForGetCustomersInMessageCustomersPage:(NSInteger)skip
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[NSNumber numberWithInteger:skip]                 forKey:@"skip"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetCustomersInMessageCustomersPage:(NSInteger)skip
                                         delegate:(id<FMAMessageCustomersUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetEmployeesInMessageEmployeesPageWithFilterParams"];
    
    NSDictionary *params = [self requestParamsForGetCustomersInMessageCustomersPage:skip];
    
    [PFCloud callFunctionInBackground:@"getCustomersInMessageCustomersPage"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetCustomersInMessageCustomersPageDidRespondWithCustomers:object];
     }];
}

@end
