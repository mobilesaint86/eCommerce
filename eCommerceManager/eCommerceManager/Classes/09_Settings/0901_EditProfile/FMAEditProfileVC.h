//
//  FMAEditProfileVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/31/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD.h"
#import "FMAWeekdayPickerView.h"
#import "FMAImagePickerAM.h"
#import "FMABackgroundUtil.h"

@class FMAEditProfileVC;
// --------------------------------------------------------------------------------------
// FMAEditProfileVCDelegate Protocol
// --------------------------------------------------------------------------------------
@protocol FMAEditProfileVCDelegate <NSObject>

- (void)editProfileVC:(FMAEditProfileVC *)controller didSaveProfile:(PFObject *)profile;

@end

// --------------------------------------------------------------------------------------
// FMAEditProfileVC Class
// --------------------------------------------------------------------------------------
@interface FMAEditProfileVC : UITableViewController<UITextFieldDelegate, FMAWeekdayPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FMAImagePickerAMDelegate, FMABackgroundUtilDelegate>
{
    UITextField *activeField;
    UIImage     *imageCompanyLogo;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic)  id<FMAEditProfileVCDelegate> delegate;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)  MBProgressHUD   *hud;

// --------------------------------------------------------------------------------------
@property (strong,  nonatomic) IBOutletCollection(UILabel) NSArray       *labelContainers;

// --------------------------------------------------------------------------------------
@property (strong,  nonatomic)                  UIDatePicker         *datePickerStartHour;
@property (strong,  nonatomic)                  UIDatePicker         *datePickerEndHour;
@property (strong,  nonatomic)                  FMAWeekdayPickerView *weekdayPickerStartDay;
@property (strong,  nonatomic)                  FMAWeekdayPickerView *weekdayPickerEndDay;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    PFImageView         *imageviewCompanyLogo;
@property (weak,    nonatomic)      IBOutlet    UITextField         *txtCompanyName;
@property (weak,    nonatomic)      IBOutlet    UITextField         *txtStreetAddress;
@property (weak,    nonatomic)      IBOutlet    UITextField         *txtPhoneNumber;
@property (weak,    nonatomic)      IBOutlet    UITextField         *txtStartHour;
@property (weak,    nonatomic)      IBOutlet    UITextField         *txtEndHour;
@property (weak,    nonatomic)      IBOutlet    UITextField         *txtStartDay;
@property (weak,    nonatomic)      IBOutlet    UITextField         *txtEndDay;

@end
