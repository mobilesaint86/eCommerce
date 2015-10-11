//
//  FMAEmployeesUtil.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/23/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

// -----------------------------------------------------------------------------------------
// FMAEmployeesUtilDelegate Protocol
// -----------------------------------------------------------------------------------------
@protocol FMAEmployeesUtilDelegate<NSObject>

- (void)requestGetEmployeesInEmployeesPageWithFilterParamsDidRespondWithEmployees:(NSArray *)employees;

@end

// -----------------------------------------------------------------------------------------
// FMAEmployeesUtilUtil Class
// -----------------------------------------------------------------------------------------
@interface FMAEmployeesUtil : NSObject

// -----------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetEmployeesInEmployeesPageWithFilterParams:(NSInteger)skip
                                                  delegate:(id<FMAEmployeesUtilDelegate>)delegate;

@end
