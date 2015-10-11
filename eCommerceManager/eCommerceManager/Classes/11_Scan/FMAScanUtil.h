//
//  FMAScanUtil.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/16/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

// --------------------------------------------------------------------------------------------
// FMAScanUtilDelegate Protocol
// --------------------------------------------------------------------------------------------
@protocol FMAScanUtilDelegate<NSObject>

- (void)requestGetProductByBarcodeDidRespondWithProduct:(id)product;

@end

// --------------------------------------------------------------------------------------------
// FMAScanUtil Class
// --------------------------------------------------------------------------------------------
@interface FMAScanUtil : NSObject

// --------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)addProduct:(PFObject *)product toCart:(NSMutableArray *)cart;
+ (NSInteger)itemsCountFromCart:(NSArray *)cart;
+ (CGFloat)totalPriceFromCart:(NSArray *)cart;

// --------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetProductByBarcode:(NSString *)barcode delegate:(id<FMAScanUtilDelegate>)delegate;

@end
