//
//  FMAUserUtil.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/13/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

// --------------------------------------------------------------------------------------
// FMAFacebookUtilDelegate Protocol
// --------------------------------------------------------------------------------------
@protocol FMAFacebookUtilDelegate <NSObject>

@optional

// PFFacebookUtilError
- (void)facebookUtilError:(NSError *)error;

// FacebookRequestMe Functions
- (void)facebookRequestMeError:(NSError *)error;
- (void)facebookRequestMeDidLoadWithResult:(id)result;

// Facebook Link Functions
- (void)facebookLinkDone;
- (void)facebookUnlinkDone;

@end

// --------------------------------------------------------------------------------------
// FMAUserUtil Class
// --------------------------------------------------------------------------------------
@interface FMAUserUtil : NSObject

// --------------------------------------------------------------------------------------
#pragma mark - Functions on Logged-In and Logged-Out
+ (void)doOnLogin;
+ (void)doOnLogout;

// --------------------------------------------------------------------------------------
#pragma mark - Installation Functions
+ (void)connectCurrentUserToInstallation;
+ (void)deconnectCurrentUserFromInstallation;

// --------------------------------------------------------------------------------------
#pragma mark - Location Functions
+ (void)updateUserLocation:(CLLocation *)location;

// --------------------------------------------------------------------------------------
#pragma mark - Facebook Functions
+ (NSArray *)facebookPersmissions;
+ (void)linkFacebookWithDelegate:(id<FMAFacebookUtilDelegate>)delegate;
+ (void)unlinkFacebookWithDelegate:(id<FMAFacebookUtilDelegate>)delegate;
+ (void)startFacebookRequestMeWithDelegate:(id<FMAFacebookUtilDelegate>)delegate;

@end
