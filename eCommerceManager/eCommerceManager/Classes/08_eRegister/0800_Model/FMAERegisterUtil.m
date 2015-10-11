//
//  FMAERegisterUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/29/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAERegisterUtil.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"

@implementation FMAERegisterUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAERegisterUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - App Setting Functions For Credit Card
+ (void)storeCreditCard:(PKCard *)card
{
    [self printLogWith:@"storeCreditCard"];
    
    NSMutableArray *cardDataList = [self getCreditCardDataListFromAppSettings];
    
    [cardDataList addObject:[card dataArchived]];
    
    [FMAUtil setAppSettingValue:cardDataList ByKey:APP_SETTING_KEY_CREDIT_CARDS];
}

+ (void)deleteCreditCardByIndex:(NSInteger)index
{
    [self printLogWith:@"deleteCreditCardByIndex"];
    
    NSMutableArray *cardDataList = [self getCreditCardDataListFromAppSettings];
    
    if (index < [cardDataList count])
    {
        [cardDataList removeObjectAtIndex:index];
    }
    
    [FMAUtil setAppSettingValue:cardDataList ByKey:APP_SETTING_KEY_CREDIT_CARDS];
}

+ (NSMutableArray *)getCreditCardDataListFromAppSettings
{
    [self printLogWith:@"getCreditCardDataListFromAppSettings"];
    
    NSMutableArray *res = [[NSMutableArray alloc] init];
    
    if ([FMAUtil checkKeyExistInAppSettings:APP_SETTING_KEY_CREDIT_CARDS])
    {
        [res addObjectsFromArray:[FMAUtil appSettingValueByKey:APP_SETTING_KEY_CREDIT_CARDS]];
    }
    
    return res;
}

// -------------------------------------------------------------------------------------------------------------------
// App Setting Functions For Bank Accounts
// -------------------------------------------------------------------------------------------------------------------
#pragma mark -
+ (void)storeBank:(FMABank *)bank
{
    [self printLogWith:@"storeBank"];
    
    NSMutableArray *bankDataList = [self getBankDataListFromAppSettings];
    
    [bankDataList addObject:[bank dataArchived]];
    
    [FMAUtil setAppSettingValue:bankDataList ByKey:APP_SETTING_KEY_BANKS];
}

+ (void)deleteBankByIndex:(NSInteger)index
{
    [self printLogWith:@"deleteBankByIndex"];
    
    NSMutableArray *bankDataList = [self getBankDataListFromAppSettings];
    
    if (index < [bankDataList count])
    {
        [bankDataList removeObjectAtIndex:index];
    }
    
    [FMAUtil setAppSettingValue:bankDataList ByKey:APP_SETTING_KEY_BANKS];
}

+ (NSMutableArray *)getBankDataListFromAppSettings
{
    [self printLogWith:@"getBankDataListFromAppSettings"];
    
    NSMutableArray *res = [[NSMutableArray alloc] init];
    
    if ([FMAUtil checkKeyExistInAppSettings:APP_SETTING_KEY_BANKS])
    {
        [res addObjectsFromArray:[FMAUtil appSettingValueByKey:APP_SETTING_KEY_BANKS]];
    }
    
    return res;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSMutableArray *)cardList
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    
    NSArray *dataList = [self getCreditCardDataListFromAppSettings];
    
    for (NSData *data in dataList)
    {
        PKCard *card = [PKCard objectUnarchivedFromData:data];
        
        [res addObject:card];
    }
    
    return res;
}

+ (NSMutableArray *)bankList
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    
    NSArray *dataList = [self getBankDataListFromAppSettings];
    
    for (NSData *data in dataList)
    {
        FMABank *bank = [FMABank objectUnarchivedFromData:data];
        
        [res addObject:bank];
    }
    
    return res;
}

+ (CGFloat)totalAmountFromBalance:(NSDictionary *)balance
{
    CGFloat res = [balance[kFMBalanceAvailableKey] floatValue] + [balance[kFMBalancePendingKey] floatValue];
    return res;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetBalance:(id<FMAERegisterUtilDelegate>)delegate
{
    [self printLogWith:@"requestGetBalance"];
    
    [PFCloud callFunctionInBackground:@"getBalance"
                       withParameters:@{}
                                block:^(id object, NSError *error)
     {
         [self printLogWith:@"- PFCloud call finished."];
         
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
             [delegate eRegisterUtilDelegateHideHud];
         }
         else
         {
             [delegate requestGetBalanceDidRespondWithBalance:object];
         }
     }];
}


@end
