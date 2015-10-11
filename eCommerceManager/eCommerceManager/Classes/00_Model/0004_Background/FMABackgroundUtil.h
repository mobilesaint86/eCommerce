//
//  FMABackgroundUtil.h
//  eCommerceManager
//
//  Created by Albert Chen on 10/6/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

// ---------------------------------------------------------------------------------------
// FMABackgroundUtilDelegate Protocol
// ---------------------------------------------------------------------------------------
@protocol  FMABackgroundUtilDelegate<NSObject>

- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew;

@end

// ---------------------------------------------------------------------------------------
// FMABackgroundUtil Class
// ---------------------------------------------------------------------------------------
@interface FMABackgroundUtil : NSObject

// ---------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSString *)imagePathDir;
+ (NSString *)fileNameForBackgroundName:(NSString *)backgroundName;
+ (NSDictionary *)notificationObjectWithImage:(UIImage *)image forBackgroundName:(NSString *)backgroundName;

// ---------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestBackgroundForName:(NSString *)backgroundName
                        delegate:(id<FMABackgroundUtilDelegate>)delegate;

@end
