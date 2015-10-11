//
//  FMACheckoutUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/20/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMACheckoutUtil.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAUserSetting.h"
#import "FMAScanUtil.h"

@implementation FMACheckoutUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMACheckoutUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (CGFloat)subTotalPriceFromCart:(NSArray *)cart
{
    [self printLogWith:@"subTotalPriceFromCart"];
    
    return [FMAScanUtil totalPriceFromCart:cart];
}

+ (CGFloat)salesTaxFromCart:(NSArray *)cart
{
    [self printLogWith:@"salesTaxFromCart"];
    
    return [self subTotalPriceFromCart:cart] * 0.024;
}

+ (CGFloat)grandTotalPriceFromCart:(NSArray *)cart
{
    [self printLogWith:@"grandTotalPriceFromCart"];
    
    CGFloat shippingRate = 0;
    
    CGFloat grandTotal  = [self subTotalPriceFromCart:cart] + shippingRate + [self salesTaxFromCart:cart];
    
    return grandTotal;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Param Functions
+ (NSArray *)cartRequestParamFromCart:(NSArray *)cart
{
    [self printLogWith:@"cartRequestParamFromCart"];
    
    NSMutableArray *res = [NSMutableArray array];
    
    for (id cc in cart)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        PFObject *product = cc[kFMCartProductKey];
        
        [dic setObject:product.objectId         forKey:kFMCartProductKey];
        [dic setObject:cc[kFMCartQuantityKey]   forKey:kFMCartQuantityKey];
        
        [res addObject:dic];
    }
    
    return res;
}

@end
