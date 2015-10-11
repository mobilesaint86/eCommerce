//
//  FMAPendingOrdersUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/23/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAPendingOrdersUtil.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"

@implementation FMAPendingOrdersUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAPendingOrdersUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)setFirstProductImageFromOrder:(PFObject *)order toImageView:(PFImageView *)imageview
{
    PFObject *p1 = [order[kFMOrderProductsKey] objectAtIndex:0];
    
    imageview.image = nil;
    imageview.file = [p1[kFMProductImagesKey] objectAtIndex:0];
    [imageview loadInBackground];
}

+ (void)setProductTitlesFromOrder:(PFObject *)order toLabel:(UILabel *)label
{
    NSArray *products = order[kFMOrderProductsKey];
    
    NSMutableString *res = [[NSMutableString alloc] init];
    for (PFObject *p in products)
    {
        if ([FMAUtil isStringEmpty:res])
        {
            [res appendString:p[kFMProductTitleKey]];
        }
        else
        {
            [res appendFormat:@", %@", p[kFMProductTitleKey]];
        }
    }
    
    label.text = res;
}

+ (void)setOrderStatusFromOrder:(PFObject *)order toLabel:(UILabel *)label
{
    PFObject *orderStatus = order[kFMOrderStatusKey];
    
    label.text = orderStatus[kFMOrderStatusNameKey];
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForGetPendingOrders:(NSInteger)skip searchString:(NSString *)searchString
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[NSNumber numberWithInteger:skip] forKey:@"skip"];
    [params setObject:searchString                      forKey:@"searchString"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetPendingOrders:(NSInteger)skip searchString:(NSString *)searchString
                     delegate:(id<FMAPendingOrdersUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetPendingOrders"];
    
    NSDictionary *params = [self requestParamsForGetPendingOrders:skip searchString:searchString];
    
    [PFCloud callFunctionInBackground:@"getPendingOrders"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetPendingOrdersDidRespondWithOrders:object];
     }];
}

@end
