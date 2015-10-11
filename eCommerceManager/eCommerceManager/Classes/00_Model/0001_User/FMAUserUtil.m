//
//  FMAUserUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/13/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAUserUtil.h"
#import "FMAUtil.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAThemeManager.h"
#import "UIImage+Alpha.h"
#import "UIImage+ResizeAdditions.h"

@implementation FMAUserUtil

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAUserUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - Functions on Log-in and Log-out
+ (void)doOnLogin
{
    [self printLogWith:@"doOnLogin"];
    
    [FMAUserUtil connectCurrentUserToInstallation];
}

+ (void)doOnLogout
{
    [self printLogWith:@"doOnLogout"];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    // Logout
    [PFUser logOut];
    
    [self deconnectCurrentUserFromInstallation];
}

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - Installation Functions
+ (void)connectCurrentUserToInstallation
{
    [self printLogWith:@"connectCurrentUserToInstallation"];
    
    [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:kFMInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
}

+ (void)deconnectCurrentUserFromInstallation
{
    [self printLogWith:@"deconnectCurrentUserFromInstallation"];
    
    [[PFInstallation currentInstallation] removeObjectForKey:kFMInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
}

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - Location Functions
+ (void)updateUserLocation:(CLLocation *)location
{
    [self printLogWith:@"updateUserLocation"];
    
    if (![PFUser currentUser]) return;
    
    PFUser *user = [PFUser currentUser];
    
    user[kFMUserLocationKey] = [PFGeoPoint geoPointWithLocation:location];
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
        }
        else
        {
            [self printLogWith:@": User location updated successfully"];
        }
    }];
}

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - Facebook Functions
+ (NSArray *)facebookPersmissions
{
    NSArray *permissions = @[@"user_about_me", @"read_friendlists", @"user_birthday", @"email", @"public_profile"];
    //@"email", @"public_profile", @"user_friends", @"user_photos",
    
    return permissions;
}

+ (void)linkFacebookWithDelegate:(id<FMAFacebookUtilDelegate>)delegate
{
    PFUser *user = [PFUser currentUser];
    
    [PFFacebookUtils linkUser:user permissions:[FMAUserUtil facebookPersmissions] block:^(BOOL succeeded, NSError *error)
     {
         if (error)
         {
             [delegate facebookUtilError:error];
         }
         else
         {
             [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
              {
                  if (!error)
                  {
                      // Save facebookId
                      user[kFMUserFacebookIDKey] = result[kFMFacebookResultIDKey];
                      [user saveInBackground];
                      
                      [delegate facebookLinkDone];
                  }
                  else
                  {
                      [delegate facebookRequestMeError:error];
                  }
              }];
         }
     }];
}

+ (void)unlinkFacebookWithDelegate:(id<FMAFacebookUtilDelegate>)delegate
{
    PFUser *user = [PFUser currentUser];
    
    [PFFacebookUtils unlinkUserInBackground:user block:^(BOOL succeeded, NSError *error)
     {
         if (error)
         {
             [delegate facebookUtilError:error];
         }
         else
         {
             // Remove facebookId
             [user removeObjectForKey:kFMUserFacebookIDKey];
             [user saveInBackground];
             
             [delegate facebookUnlinkDone];
         }
     }];
}

+ (void)startFacebookRequestMeWithDelegate:(id<FMAFacebookUtilDelegate>)delegate
{
    [self printLogWith:@"startFacebookRequestMe"];
    
    // Start facebook request for me
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (!error)
         {
             [delegate facebookRequestMeDidLoadWithResult:result];
         }
         else
         {
             [delegate facebookRequestMeError:error];
         }
     }];
}

@end
