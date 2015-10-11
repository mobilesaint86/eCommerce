//
//  FMACustomerMessageUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/26/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMACustomerMessageUtil.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"

@implementation FMACustomerMessageUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMACustomerMessageUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSString *)otherUserObjectIDFromMessage:(PFObject *)message
{
    PFUser *from = message[kFMMessageFromKey], *to = message[kFMMessageToKey];
    PFUser *user = [PFUser currentUser];
    
    if ([from.objectId isEqualToString:user.objectId])
    {
        return to.objectId;
    }
    
    return from.objectId;
}

+ (NSString *)senderIDFromMessage:(PFObject *)message
{
    PFUser *from = message[kFMMessageFromKey];
    
    return from.objectId;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForGetMessagesInCustomerMessagePage:(NSInteger)skip other:(PFUser *)other
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[NSNumber numberWithInteger:skip] forKey:@"skip"];
    [params setObject:other.objectId                    forKey:@"other"];
    
    return params;
}

+ (NSDictionary *)requestParamsForGetLatestMessagesInCustomerMessagePage:(NSDate *)lastDate other:(PFUser *)other
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:lastDate          forKey:@"lastDate"];
    [params setObject:other.objectId    forKey:@"other"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetMessagesInCustomerMessagePage:(NSInteger)skip
                                          other:(PFUser *)other
                                       delegate:(id<FMACustomerMessageUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetMessagesInCustomerMessagePage"];
    
    NSDictionary *params = [self requestParamsForGetMessagesInCustomerMessagePage:skip other:other];
    
    [PFCloud callFunctionInBackground:@"getMessagesInCustomerMessagePage"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetMessagesInCustomerMessagePageDidRespondWithMessages:object];
     }];
}

+ (void)requestGetLatestMessagesInCustomerMessagePage:(NSDate *)lastDate
                                                other:(PFUser *)other
                                             delegate:(id<FMACustomerMessageUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetLatestMessagesInCustomerMessagePage"];
    
    NSDictionary *params = [self requestParamsForGetLatestMessagesInCustomerMessagePage:lastDate other:other];
    
    [PFCloud callFunctionInBackground:@"getLatestMessagesInCustomerMessagePage"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetLatestMessagesInCustomerMessagePageDidRespondWithMessages:object];
     }];
}

@end
