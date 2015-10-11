//
//  FMAShareUtil.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/28/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>

// ------------------------------------------------------------------------------
// FMAShareUtilDelegate Protocol
// ------------------------------------------------------------------------------
@protocol FMAShareUtilDelegate<NSObject>

- (void)shareUtilDelegateDidCompleteShare;

@end

// ------------------------------------------------------------------------------
// FMAShareUtil Class
// ------------------------------------------------------------------------------
@interface FMAShareUtil : NSObject

// ------------------------------------------------------------------------------
#pragma mark - Facebook Share Functions
+ (void)shareViaFacebookWithProduct:(PFObject *)product
                           delegate:(id<FMAShareUtilDelegate>)delegate;

// ------------------------------------------------------------------------------
#pragma mark - Email Share Functions
+ (MFMailComposeViewController *)shareViaEmailWithProduct:(PFObject *)product delegate:(id)delgate;

@end
