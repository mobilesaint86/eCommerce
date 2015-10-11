//
//  FMACheckoutUtil.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/20/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FMACheckoutUtil : NSObject

// --------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (CGFloat)subTotalPriceFromCart:(NSArray *)cart;
+ (CGFloat)salesTaxFromCart:(NSArray *)cart;
+ (CGFloat)grandTotalPriceFromCart:(NSArray *)cart;

// -------------------------------------------------------------------------------------------
#pragma mark - Request Param Functions
+ (NSArray *)cartRequestParamFromCart:(NSArray *)cart;

@end
