//
//  FMATotalOrdersUtil.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/23/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

// -----------------------------------------------------------------------------------------
// FMATotalOrdersUtilDelegate Protocol
// -----------------------------------------------------------------------------------------
@protocol FMATotalOrdersUtilDelegate<NSObject>

- (void)requestGetTotalOrdersDidRespondWithOrders:(NSArray *)orders;

@end

// -----------------------------------------------------------------------------------------
// FMATotalOrdersUtil Class
// -----------------------------------------------------------------------------------------
@interface FMATotalOrdersUtil : NSObject

// -----------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)setFirstProductImageFromOrder:(PFObject *)order toImageView:(PFImageView *)imageview;
+ (void)setProductTitlesFromOrder:(PFObject *)order toLabel:(UILabel *)label;
+ (void)setOrderStatusFromOrder:(PFObject *)order toLabel:(UILabel *)label;

// -----------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetTotalOrders:(NSInteger)skip searchString:(NSString *)searchString
                     delegate:(id<FMATotalOrdersUtilDelegate>)delegate;

@end
