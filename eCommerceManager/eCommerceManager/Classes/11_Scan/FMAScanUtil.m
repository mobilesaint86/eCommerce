//
//  FMAScanUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/16/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAScanUtil.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAUserSetting.h"

@implementation FMAScanUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAScanUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSUInteger)indexOfProduct:(PFObject *)product inCart:(NSArray *)cart
{
    int i = 0;
    for (NSDictionary *k in cart)
    {
        PFObject *p1 = k[kFMCartProductKey];
        
        if ([p1.objectId isEqualToString:product.objectId])
        {
            return i;
        }
        i++;
    }
    
    return NSNotFound;
}

+ (void)addProduct:(PFObject *)product toCart:(NSMutableArray *)cart
{
    NSUInteger index = [self indexOfProduct:product inCart:cart];
    if ( index == NSNotFound)
    {
        NSMutableDictionary *tt = [NSMutableDictionary dictionary];
        
        [tt setObject:product   forKey:kFMCartProductKey];
        [tt setObject:@(1)      forKey:kFMCartQuantityKey];
        
        [cart addObject:tt];
    }
    else
    {
        NSMutableDictionary *tt = [cart objectAtIndex:index];
        
        int newQuantity = [tt[kFMCartQuantityKey] intValue];
        
        tt[kFMCartQuantityKey] = [NSNumber numberWithInt:newQuantity+1];
    }
}

+ (NSInteger)itemsCountFromCart:(NSArray *)cart
{
    [self printLogWith:@"itemsCount"];
    
    NSInteger res = 0;
    
    for (NSDictionary *tt in cart)
    {
        res = res + [tt[kFMCartQuantityKey] intValue];
    }
    
    return res;
}

+ (CGFloat)totalPriceFromCart:(NSArray *)cart
{
    [self printLogWith:@"totalPrice"];
    
    CGFloat res = 0.f;
    
    for (NSDictionary *tt in cart)
    {
        int n         = [tt[kFMCartQuantityKey] intValue];
        CGFloat price = [[tt[kFMCartProductKey] objectForKey:kFMProductPriceKey] floatValue];
        
        res = res + n * price;
    }
    
    return res;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForGetProductByBarcode:(NSString *)barcode
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:barcode forKey:@"barcode"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetProductByBarcode:(NSString *)barcode delegate:(id<FMAScanUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetProductsInBrowsePageWithSkip"];
    
    NSDictionary *params = [self requestParamsForGetProductByBarcode:barcode];
    
    [PFCloud callFunctionInBackground:@"getProductByBarcode"
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
             [delegate requestGetProductByBarcodeDidRespondWithProduct:object];
         }
     }];
}

@end
