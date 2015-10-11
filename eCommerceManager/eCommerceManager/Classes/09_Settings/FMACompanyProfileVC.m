//
//  FMACompanyProfileVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/30/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMACompanyProfileVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMABackgroundSetting.h"

#define CELLID                      @"CompanyProfileCVCell"

#define SEGID_EDITPROFILE           @"SEGID_EditProfile"

@interface FMACompanyProfileVC ()

@end

@implementation FMACompanyProfileVC
{
    NSArray         *dataSource;
    NSMutableArray *checkedList;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMACompanyProfileVC) return;
    
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
    
    [self unregisterNotifications];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
    [self initDataSource];
    [self registerNotifications];
    [self initCompanyProfile];
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
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameSettings delegate:self];
    
    _viewBack1.backgroundColor      = [UIColor clearColor];
    _viewBack2.backgroundColor      = [UIColor clearColor];
    
    [FMAThemeManager setBorderToView:_imageviewCompanyLogo width:1.f Color:[UIColor lightGrayColor]];
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    dataSource  = @[@"Shipping",    @"Pick up",     @"Delivery"];
    
    checkedList = [[NSMutableArray alloc] init];
    
    [checkedList addObject:[NSNumber numberWithBool:YES]];
    [checkedList addObject:[NSNumber numberWithBool:YES]];
    [checkedList addObject:[NSNumber numberWithBool:YES]];
    
    [checkedList addObject:[NSNumber numberWithBool:NO]];
    [checkedList addObject:[NSNumber numberWithBool:NO]];
    [checkedList addObject:[NSNumber numberWithBool:NO]];
    [checkedList addObject:[NSNumber numberWithBool:NO]];
    
    [checkedList addObject:[NSNumber numberWithBool:YES]];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Notification Functions
- (void)registerNotifications
{
    [self printLogWith:@"registerNotifications"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundImageChanged:)
                                                 name:FMABackgroundSettingDidUpdateNotification object:nil];
}

- (void)unregisterNotifications
{
    [self printLogWith:@"unregisterNotifications"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:FMABackgroundSettingDidUpdateNotification object:nil];
}

- (void)backgroundImageChanged:(NSNotification *)note
{
    [self printLogWith:@"backgroundImageChanged"];
    
    if ([note.object[kFMBackgroundNameKey] isEqualToString:kFMBackgroundNameSettings])
    {
        if ([note.object objectForKey:kFMBackgroundImageKey])
        {
            [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
        }
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Init Company Profile
- (void)initCompanyProfile
{
    [self printLogWith:@"initCompanyProfile"];
    
    PFQuery *query = [PFQuery queryWithClassName:kFMCompanyClassKey];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error)
        {
            [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
        }
        else
        {
            [self setCompanyProfileWithObject:objects[0]];
        }
    }];
}

- (void)setCompanyProfileWithObject:(PFObject *)profile
{
    [self printLogWith:@"setCompanyProfileWithObject"];
    
    _imageviewCompanyLogo.image = nil;
    _imageviewCompanyLogo.file = profile[kFMCompanyLogoKey];
    [_imageviewCompanyLogo loadInBackground];
    
    _labelName.text             = profile[kFMCompanyNameKey];
    _labelStreet.text           = profile[kFMCompanyStreetAddressKey];
    _labelPhoneNumber.text      = profile[kFMCompanyPhoneNumberKey];
    _labelHoursOperation.text   = [NSString stringWithFormat:@"%@ - %@: %@ - %@",
                                   profile[kFMCompanyStartWeekdayKey], profile[kFMCompanyEndWeekdayKey],
                                   profile[kFMCompanyOpenHourKey], profile[kFMCompanyCloseHourKey]];
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
    
    if ([segue.identifier isEqualToString:SEGID_EDITPROFILE])
    {
        FMAEditProfileVC *vc = [FMAUtil vcFromSegue:segue];
        
        vc.delegate = self;
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAEditProfileVCDelegate
- (void)editProfileVC:(FMAEditProfileVC *)controller didSaveProfile:(PFObject *)profile
{
    [self printLogWith:@"editProfileVC: didSaveProfile"];
    
    [self setCompanyProfileWithObject:profile];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
