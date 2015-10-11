//
//  FMAMessageCustomersUtil.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/26/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

// -----------------------------------------------------------------------------------------
// FMAMessageCustomersUtilDelegate Protocol
// -----------------------------------------------------------------------------------------
@protocol FMAMessageCustomersUtilDelegate<NSObject>

- (void)requestGetCustomersInMessageCustomersPageDidRespondWithCustomers:(NSArray *)customers;

@end

// -----------------------------------------------------------------------------------------
// FMAMessageCustomersUtil Class
// -----------------------------------------------------------------------------------------
@interface FMAMessageCustomersUtil : NSObject

// -----------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)setDistanceLabel:(UILabel *)labelDistance withUser:(PFUser *)other;

// -----------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetCustomersInMessageCustomersPage:(NSInteger)skip
                                         delegate:(id<FMAMessageCustomersUtilDelegate>)delegate;

@end
