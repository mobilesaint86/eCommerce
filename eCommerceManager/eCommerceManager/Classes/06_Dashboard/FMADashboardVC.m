//
//  FMADashboardVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/22/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMADashboardVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMARevenueVC.h"
#import "FMABackgroundSetting.h"
#import "FMATotalOrders2VC.h"

#define SEGID_TOTALREVENUE              @"SEGID_TotalRevenue"
#define SEGID_TOTALORDERS               @"SEGID_TotalOrders"
#define SEGID_TOTALORDERS2              @"SEGID_TotalOrders2"
#define SEGID_PENDINGORDERS             @"SEGID_PendingOrders"
#define SEGID_PENDINGORDERS2            @"SEGID_PendingOrders2"
#define SEGID_CUSTOMERREVIEWS           @"SEGID_CustomerReviews"
#define SEGID_SECURITYCAMERAS           @"SEGID_SecurityCameras"
#define SEGID_EMPLOYESS                 @"SEGID_Employees"
#define SEGID_PAYROLL                   @"SEGID_Payroll"
#define SEGID_WORKSCHEDULE              @"SEGID_WorkSchedule"

@interface FMADashboardVC ()

@end

@implementation FMADashboardVC

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMADashboardVC) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self printLogWith:@"initWithCoder"];
    
    if ((self = [super initWithCoder:aDecoder]))
    {
    }
    return self;
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewDidLayoutSubviews
{
    [self printLogWith:@"viewDidLayoutSubviews"];
    [super viewDidLayoutSubviews];
    
    [FMAThemeManager relayoutTableviewForApp:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [self printLogWith:@"didReceiveMemoryWarning"];
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initViewBackground];
    [self initLabels];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameDashboard toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameDashboard delegate:self];
}

- (void)initLabels
{
    [self printLogWith:@"initLabels"];
    
    [FMADashboardUtil initDateBarButtonItem:_barButtonDate];
    
    [FMADashboardUtil requestGetTotalRevenueInDashboardPageWithParams:_labelTotalRevenue];
    
    [FMADashboardUtil requestGetNumberOfTotalOrdersInDashboardPageWithParams:_labelTotalOrders];
    
    [FMADashboardUtil requestGetNumberOfPendingOrdersInDashboardPageWithParams:_labelPendingOrders];
    
    [FMADashboardUtil requestGetNumberOfEmployeesInDashboardPageWithParams:_labelEmployees];
    
    [FMADashboardUtil requestGetTotalNumberOfReviewsInDashboardPage:_labelCustomerReviews];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameDashboard toImageView:_imageviewBackground];
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnMenu:(id)sender
{
    [self printLogWith:@"onBtnMenu"];
    
    [self.frostedViewController presentMenuViewController];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_TOTALREVENUE])
    {
    }
    if ([segue.identifier isEqualToString:SEGID_TOTALORDERS])
    {
    }
    if ([segue.identifier isEqualToString:SEGID_TOTALORDERS2])
    {
    }
    if ([segue.identifier isEqualToString:SEGID_PENDINGORDERS])
    {
    }
    if ([segue.identifier isEqualToString:SEGID_PENDINGORDERS2])
    {
    }
    if ([segue.identifier isEqualToString:SEGID_CUSTOMERREVIEWS])
    {
    }
    if ([segue.identifier isEqualToString:SEGID_SECURITYCAMERAS])
    {
    }
    if ([segue.identifier isEqualToString:SEGID_EMPLOYESS])
    {
    }
    if ([segue.identifier isEqualToString:SEGID_PAYROLL])
    {
    }
    if ([segue.identifier isEqualToString:SEGID_WORKSCHEDULE])
    {
    }
}

@end
