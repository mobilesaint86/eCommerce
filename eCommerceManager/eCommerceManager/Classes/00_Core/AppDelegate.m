//
//  AppDelegate.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/15/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "FMAData.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMAUserUtil.h"
#import "FMAConstants.h"
#import "FMABackgroundSetting.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugAppDelegate) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initApp
{
    [self printLogWith:@"initApp"];
    
    [FMAThemeManager initAppTheme];
    
    // Set up Parse Application ID and Client Key
    [Parse setApplicationId:[FMAUtil parseApplicationID] clientKey:[FMAUtil parseClientKey]];
    
    // Register for remote notifications
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge|
                                                                  UIUserNotificationTypeSound|
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        [[UIApplication sharedApplication]
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)];
    }
    
    // Integrate Facebook
    [PFFacebookUtils initializeFacebook];
    
    // Setup StatusBar Style
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Start LocationController
    _coreLocationController          = [[FMACoreLocationController alloc] init];
    _coreLocationController.delegate = self;
    [_coreLocationController startUpdateLocation];
    
    // Configure backgrounds
    [[FMABackgroundSetting sharedInstance] configureBlurImages];
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Application LifeCycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self printLogWith:@"application: didFinishLaunchingWithOptions"];
    
    [self initApp];
    
    [self setupSceneOnAppLaunch];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self printLogWith:@"applicationWillResignActive"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self printLogWith:@"applicationDidEnterBackground"];
    
    [_coreLocationController stopUptateLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self printLogWith:@"applicationWillEnterForeground"];
    
    [_coreLocationController startUpdateLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self printLogWith:@"applicationDidBecomeActive"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self printLogWith:@"applicationWillTerminate"];
    
    [_coreLocationController stopUptateLocation];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Push Notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    [self printLogWith:@"application: didRegisterForRemoteNotificationsWithDeviceToken"];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    [currentInstallation setDeviceTokenFromData:devToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    [self printLogWith:@"application: didFailToRegisterForRemoteNotificationsWithError"];
    [self printLogWith:[err localizedDescription]];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [self printLogWith:@"application: didRegisterUserNotificationSettings"];
    
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    [self printLogWith:@"application: handleActionWithIdentifier:"];
    
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self printLogWith:@"application didReceiveRemoteNotification"];
    
    if ([userInfo[kFMPushPayloadTypeKey] isEqualToString:kFMPushPayloadTypeM4B])
    {
        if ([FMAUtil isObjectEmpty:_currentMessageVC] ||
            ![[FMAUtil classNameFromObject:_currentMessageVC] isEqualToString:@"FMAMessageBoardVC"])
        {
            NSString *alertMessage = userInfo[kAPNSAPSKey][kAPNSAlertKey];
            
            [[FMAUtil generalAlertWithTitle:@"" message:alertMessage delegate:self] show];
        }
    }
    
    if ([userInfo[kFMPushPayloadTypeKey] isEqualToString:kFMPushPayloadTypeM2M])
    {
        if ([FMAUtil isObjectEmpty:_currentMessageVC] ||
            ![[FMAUtil classNameFromObject:_currentMessageVC] isEqualToString:@"FMAEmployeeMessageVC"] ||
            ([[FMAUtil classNameFromObject:_currentMessageVC] isEqualToString:@"FMAEmployeeMessageVC"] &&
             ![[(FMAEmployeeMessageVC *)_currentMessageVC other].objectId isEqualToString:userInfo[kFMPushPayloadFromUserIDKey]]))
        {
            NSString *alertMessage = userInfo[kAPNSAPSKey][kAPNSAlertKey];
            
            [[FMAUtil generalAlertWithTitle:@"" message:alertMessage delegate:self] show];
        }
    }
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - View Controllers Functions
- (void)setupSceneOnAppLaunch
{
    [self printLogWith:@"setupViewControllersOnAppLaunch"];

    if ([PFUser currentUser])
    {
        [self setupSceneOnLoggedIn];
    }
}

- (void)setupSceneOnLoggedIn
{
    [self printLogWith:@"setupSceneOnLoggedIn"];
    
    [FMAUserUtil doOnLogin];
    
    self.window.rootViewController = self.menuContainerVC;
}

- (void)setupSceneOnLoggedOut
{
    [self printLogWith:@"setupSceneOnLoggedOut"];
    
    self.menuContainerVC = nil;
    
    self.window.rootViewController = [FMAUtil instantiateViewControllerBySBID:SBID_FMALOGIN_VC];
}

- (void)logOut
{
    [self printLogWith:@"logOut"];
    
    [FMAUserUtil doOnLogout];
    
    [self setupSceneOnLoggedOut];
}

// -----------------------------------------------------------------------------------------------------------------------
// Getter of View Controllers
// -----------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (REFrostedViewController *)menuContainerVC
{
    [self printLogWith:@"menuContainerVC"];
    
    if (!_menuContainerVC)
    {
        _menuContainerVC = [[REFrostedViewController alloc] init];
        
        [_menuContainerVC setDelegate:self];
        [_menuContainerVC setPanGestureEnabled:NO];
        [_menuContainerVC setMenuViewSize:[self.sideMenuVC menuSize]];
        [_menuContainerVC setContentViewController:self.browseNC];
        [_menuContainerVC setMenuViewController:self.sideMenuVC];
    }
    
    return _menuContainerVC;
}

- (FMASideMenuVC *)sideMenuVC
{
    if (!_sideMenuVC)
    {
        _sideMenuVC = [FMAUtil instantiateViewControllerBySBID:SBID_FMASIDEMENU_VC];
        _sideMenuVC.delegate = self;
    }
    
    return _sideMenuVC;
}

- (UINavigationController *)browseNC
{
    if (!_browseNC)
    {
        _browseNC = [FMAUtil instantiateViewControllerBySBID:SBID_FMABROWSE_NC];
        _browseVC = [_browseNC viewControllers][0];
    }
    return _browseNC;
}

- (UINavigationController *)dashboardNC
{
    if (!_dashboardNC)
    {
        _dashboardNC = [FMAUtil instantiateViewControllerBySBID:SBID_FMADASHBOARD_NC];
        _dashboardVC = [_dashboardNC viewControllers][0];
    }
    return _dashboardNC;
}

- (UINavigationController *)messagesNC
{
    if (!_messagesNC)
    {
        _messagesNC = [FMAUtil instantiateViewControllerBySBID:SBID_FMAMESSAGES_NC];
        _messagesVC = [_messagesNC viewControllers][0];
    }
    return _messagesNC;
}

- (UINavigationController *)eRegisterNC
{
    if (!_eRegisterNC)
    {
        _eRegisterNC = [FMAUtil instantiateViewControllerBySBID:SBID_FMAEREGISTER_NC];
        _eRegisterVC = [_eRegisterNC viewControllers][0];
    }
    return _eRegisterNC;
}

- (UINavigationController *)companyProfileNC
{
    if (!_companyProfileNC)
    {
        _companyProfileNC = [FMAUtil instantiateViewControllerBySBID:SBID_FMACOMPANYPROFILE_NC];
        _companyProfileVC = [_companyProfileNC viewControllers][0];
    }
    return _companyProfileNC;
}

// -----------------------------------------------------------------------------------------------------------------------
// FMASideMenuVCDelegate
// -----------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (void)sideMenuVCDidSelectItemTitle:(NSString *)itemTitle
{
    [self printLogWith:@"sideMenuVCDidSelectItemTitle"];
    
    UINavigationController *nc;
    if ([itemTitle isEqualToString:kFMASideMenuItemTitleStore])
    {
        nc = self.browseNC;
    }
    else if ([itemTitle isEqualToString:kFMASideMenuItemTitleAbout])
    {
        //        nc = self.dashboardNC;
        nc = [FMAUtil instantiateViewControllerBySBID:SBID_FMAABOUT_NC];
    }
    else if ([itemTitle isEqualToString:kFMASideMenuItemTitleDashboard])
    {
        //        nc = self.dashboardNC;
        nc = [FMAUtil instantiateViewControllerBySBID:SBID_FMADASHBOARD_NC];
    }
    else if ([itemTitle isEqualToString:kFMASideMenuItemTitleMessages])
    {
        //        nc = self.messagesNC;
        nc = [FMAUtil instantiateViewControllerBySBID:SBID_FMAMESSAGES_NC];
    }
    else if ([itemTitle isEqualToString:kFMASideMenuItemTitleWallet])
    {
        //        nc = self.eRegisterNC;
        nc = [FMAUtil instantiateViewControllerBySBID:SBID_FMAEREGISTER_NC];
    }
    else if ([itemTitle isEqualToString:kFMASideMenuItemTitleSettings])
    {
        //        nc = self.companyProfileNC;
        nc = [FMAUtil instantiateViewControllerBySBID:SBID_FMACOMPANYPROFILE_NC];
    }
    else if ([itemTitle isEqualToString:kFMASideMenuItemTitleAddInventory])
    {
        // Add Item
        UINavigationController *nc = [FMAUtil instantiateViewControllerBySBID:SBID_FMAADDITEM_NC];
        [self.menuContainerVC.contentViewController presentViewController:nc animated:NO completion:^{
            [self.menuContainerVC hideMenuViewController];
        }];
        return;
    }
    else if ([itemTitle isEqualToString:kFMASideMenuItemTitleBarcode])
    {
        // Barcode
        UINavigationController *nc = [FMAUtil instantiateViewControllerBySBID:SBID_FMASCAN_NC];
        [self.menuContainerVC.contentViewController presentViewController:nc animated:NO completion:^{
            [self.menuContainerVC hideMenuViewController];
        }];
        return;
    }
    else if ([itemTitle isEqualToString:kFMASideMenuItemTitleLogout])
    {
        [self logOut];
        return;
    }
    else
    {
        [_menuContainerVC hideMenuViewController];
        return;
    }
    
    if (nc != self.menuContainerVC.contentViewController)
    {
        [self.menuContainerVC setContentViewController:nc];
        [_menuContainerVC hideMenuViewController];
    }
    else
    {
        [_menuContainerVC hideMenuViewController];
    }
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - REFrostedViewControllerDelegate
- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    [self printLogWith:@"frostedViewController willShowMenuViewController"];
    
    [_sideMenuVC updateViewBackground];
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - FMACoreLocationControllerDelegate
- (void)locationUpdate:(CLLocation *)location
{
    [self printLogWith:@"locationUpdate"];
    
    [FMAUserUtil updateUserLocation:location];
}

- (void)locationError:(NSError *)error
{
    [self printLogWith:@"locationError"];
    [self printLogWith:[error localizedDescription]];
}

@end
