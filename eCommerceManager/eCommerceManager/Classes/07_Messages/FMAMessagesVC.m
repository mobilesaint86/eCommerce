//
//  FMAMessagesVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/26/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAMessagesVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMABackgroundSetting.h"

#define SEGID_MESSAGECUSTOMERS               @"SEGID_MessageCustomers"
#define SEGID_MESSAGEEMPLOYEES               @"SEGID_MessageEmployees"
#define SEGID_MESSAGEBOARD                   @"SEGID_MessageBoard"

@interface FMAMessagesVC ()

@end

@implementation FMAMessagesVC

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAMessagesVC) return;
    
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
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
            
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameMessages toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameMessages delegate:self];
    
    _viewBack1.backgroundColor      = [UIColor clearColor];
    _viewBack2.backgroundColor      = [UIColor clearColor];
    _viewBack3.backgroundColor      = [UIColor clearColor];
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
    
    if ([segue.identifier isEqualToString:SEGID_MESSAGECUSTOMERS])
    {
    }
    if ([segue.identifier isEqualToString:SEGID_MESSAGEEMPLOYEES])
    {
    }
    if ([segue.identifier isEqualToString:SEGID_MESSAGEBOARD])
    {
        FMAMessageBoardVC *vc = [FMAUtil vcFromSegue:segue];
        [FMAUtil appDelegate].currentMessageVC = vc;
        vc.backgroundName = kFMBackgroundNameMessages;
    }
}

@end
