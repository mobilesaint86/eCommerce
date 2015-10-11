//
//  FMAMessageBoardUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/22/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAMessageBoardUtil.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"

@implementation FMAMessageBoardUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAMessageBoardUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSString *)senderIDFromMessage:(PFObject *)message
{
    PFUser *from = message[kFMMessageFromKey];
    
    return from.objectId;
}

+ (NSString *)userFirstNameFromSenderId:(NSString *)senderId dataSource:(NSArray *)dataSource
{
    for (PFObject *m in dataSource)
    {
        PFUser *from = m[kFMMessageFromKey];
        
        if ([from.objectId isEqualToString:senderId])
        {
            return from[kFMUserFirstNameKey];
        }
    }
    return nil;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Params Functions
+ (NSDictionary *)requestParamsForGetMessagesInMessageBoardPageWithFilterParams:(NSInteger)skip
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[NSNumber numberWithInteger:skip] forKey:@"skip"];
    
    return params;
}

+ (NSDictionary *)requestParamsForGetLatestMessagesInMessageBoardPageWithFilterParams:(NSDate *)lastDate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:lastDate          forKey:@"lastDate"];
    
    return params;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetMessagesInMessageBoardPageWithFilterParams:(NSInteger)skip
                                                    delegate:(id<FMAMessageBoardUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetMessagesInMessageBoardPageWithFilterParams"];
    
    NSDictionary *params = [self requestParamsForGetMessagesInMessageBoardPageWithFilterParams:skip];
    
    [PFCloud callFunctionInBackground:@"getMessagesInMessageBoardPageWithFilterParams"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetMessagesInMessageBoardPageWithFilterParamsDidRespondWithMessages:object];
     }];
}

+ (void)requestGetLatestMessagesInMessageBoardPageWithFilterParams:(NSDate *)lastDate
                                                          delegate:(id<FMAMessageBoardUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetLatestMessagesInMessageBoardPageWithFilterParams"];
    
    NSDictionary *params = [self requestParamsForGetLatestMessagesInMessageBoardPageWithFilterParams:lastDate];
    
    [PFCloud callFunctionInBackground:@"getLatestMessagesInMessageBoardPageWithFilterParams"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         
         [delegate requestGetLatestMessagesInMessageBoardPageWithFilterParamsDidRespondWithMessages:object];
     }];
}

@end
