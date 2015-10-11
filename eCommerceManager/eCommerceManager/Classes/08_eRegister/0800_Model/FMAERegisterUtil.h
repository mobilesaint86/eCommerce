//
//  FMAERegisterUtil.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/29/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKCard.h"
#import "FMABank.h"

// -----------------------------------------------------------------------------------------
// FMAERegisterUtilDelegate Protocol
// -----------------------------------------------------------------------------------------
@protocol FMAERegisterUtilDelegate<NSObject>

- (void)requestGetBalanceDidRespondWithBalance:(NSDictionary *)balance;
- (void)eRegisterUtilDelegateHideHud;

@end

// -----------------------------------------------------------------------------------------
// FMAERegisterUtil Class
// -----------------------------------------------------------------------------------------
@interface FMAERegisterUtil : NSObject

// --------------------------------------------------------------------------------------
#pragma mark - App Setting Functions For Credit Card
+ (void)storeCreditCard:(PKCard *)card;
+ (void)deleteCreditCardByIndex:(NSInteger)index;
+ (NSMutableArray *)getCreditCardDataListFromAppSettings;

// --------------------------------------------------------------------------------------
// App Setting Functions For Bank Accounts
// --------------------------------------------------------------------------------------
#pragma mark -
+ (void)storeBank:(FMABank *)bank;
+ (void)deleteBankByIndex:(NSInteger)index;
+ (NSMutableArray *)getBankDataListFromAppSettings;

// --------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSMutableArray *)cardList;
+ (NSMutableArray *)bankList;
+ (CGFloat)totalAmountFromBalance:(NSDictionary *)balance;

// --------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestGetBalance:(id<FMAERegisterUtilDelegate>)delegate;

@end
