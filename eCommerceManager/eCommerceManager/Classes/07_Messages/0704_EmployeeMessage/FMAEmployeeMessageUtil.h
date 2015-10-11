//
//  FMAEmployeeMessageUtil.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/22/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

// -----------------------------------------------------------------------------------------
// FMAEmployeeMessageUtilDelegate Protocol
// -----------------------------------------------------------------------------------------
@protocol FMAEmployeeMessageUtilDelegate<NSObject>

- (void)requestGetMessagesInEmployeeMessagePageWithFilterParamsDidRespondWithMessages:(NSArray *)messages;

- (void)requestGetLatestMessagesInEmployeeMessagePageWithFilterParamsDidRespondWithMessages:(NSArray *)messages;

@end

// -----------------------------------------------------------------------------------------
// FMAEmployeeMessageUtil Class
// -----------------------------------------------------------------------------------------
@interface FMAEmployeeMessageUtil : NSObject

// -----------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSString *)otherUserObjectIDFromMessage:(PFObject *)message;
+ (NSString *)senderIDFromMessage:(PFObject *)message;

// -----------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetMessagesInEmployeeMessagePageWithFilterParams:(NSInteger)skip
                                                          other:(PFUser *)other
                                                       delegate:(id<FMAEmployeeMessageUtilDelegate>)delegate;
+ (void)requestGetLatestMessagesInEmployeeMessagePageWithFilterParams:(NSDate *)lastDate
                                           other:(PFUser *)other
                                        delegate:(id<FMAEmployeeMessageUtilDelegate>)delegate;

@end
