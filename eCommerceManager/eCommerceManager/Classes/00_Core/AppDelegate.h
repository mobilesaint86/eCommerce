//
//  AppDelegate.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/15/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "FMACoreLocationController.h"
#import "FMASideMenuVC.h"
#import "FMABrowseVC.h"
#import "FMALoginVC.h"
#import "FMADashboardVC.h"
#import "FMAMessagesVC.h"
#import "FMAERegisterVC.h"
#import "FMACompanyProfileVC.h"
#import "FMAMessageBoardVC.h"
#import "FMAEmployeeMessageVC.h"
#import "REFrostedViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, FMASideMenuVCDelegate, FMACoreLocationControllerDelegate, REFrostedViewControllerDelegate>

// -------------------------------------------------------------------------------------------
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) REFrostedViewController *menuContainerVC;

@property (strong, nonatomic) FMASideMenuVC *sideMenuVC;

// -------------------------------------------------------------------------------------------
@property (strong, nonatomic) FMACoreLocationController *coreLocationController;

// -------------------------------------------------------------------------------------------
@property (strong, nonatomic) FMABrowseVC           *browseVC;
@property (strong, nonatomic) FMADashboardVC        *dashboardVC;
@property (strong, nonatomic) FMAMessagesVC         *messagesVC;
@property (strong, nonatomic) FMAERegisterVC        *eRegisterVC;
@property (strong, nonatomic) FMACompanyProfileVC   *companyProfileVC;

@property (strong, nonatomic) UINavigationController *browseNC;
@property (strong, nonatomic) UINavigationController *dashboardNC;
@property (strong, nonatomic) UINavigationController *messagesNC;
@property (strong, nonatomic) UINavigationController *eRegisterNC;
@property (strong, nonatomic) UINavigationController *companyProfileNC;

// -------------------------------------------------------------------------------------------
@property (strong, nonatomic) id currentMessageVC;

// -------------------------------------------------------------------------------------------
#pragma mark - View Controllers Functions
- (void)setupSceneOnLoggedIn;
- (void)logOut;

@end
