//
//  FMBMessageEmployeesUtil.h
//  eCommerceCustomer
//
//  Created by Albert Chen on 9/26/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

// -----------------------------------------------------------------------------------------
// FMBMessageEmployeesUtilDelegate Protocol
// -----------------------------------------------------------------------------------------
@protocol FMBMessageEmployeesUtilDelegate<NSObject>

- (void)requestGetEmployeesInMessageEmployeesPageWithFilterParamsDidRespondWithEmployees:(NSArray *)employees;

@end

// -----------------------------------------------------------------------------------------
// FMBMessageEmployeesUtil Class
// -----------------------------------------------------------------------------------------
@interface FMBMessageEmployeesUtil : NSObject

// -----------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (void)setDistanceLabel:(UILabel *)labelDistance withUser:(PFUser *)other;

// -----------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetEmployeesInMessageEmployeesPageWithFilterParams:(NSInteger)skip
                                                         delegate:(id<FMBMessageEmployeesUtilDelegate>)delegate;

@end
