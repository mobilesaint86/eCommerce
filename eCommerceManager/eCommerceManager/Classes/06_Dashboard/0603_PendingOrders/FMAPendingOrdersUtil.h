//
//  FMAPendingOrdersUtil.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/23/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

// -----------------------------------------------------------------------------------------
// FMAPendingOrdersUtilDelegate Protocol
// -----------------------------------------------------------------------------------------
@protocol FMAPendingOrdersUtilDelegate<NSObject>

- (void)requestGetPendingOrdersDidRespondWithOrders:(NSArray *)orders;

@end

// -----------------------------------------------------------------------------------------
// FMAPendingOrdersUtil Class
// -----------------------------------------------------------------------------------------
@interface FMAPendingOrdersUtil : NSObject

// -----------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)setFirstProductImageFromOrder:(PFObject *)order toImageView:(PFImageView *)imageview;
+ (void)setProductTitlesFromOrder:(PFObject *)order toLabel:(UILabel *)label;
+ (void)setOrderStatusFromOrder:(PFObject *)order toLabel:(UILabel *)label;

// -----------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetPendingOrders:(NSInteger)skip searchString:(NSString *)searchString
                       delegate:(id<FMAPendingOrdersUtilDelegate>)delegate;

@end
