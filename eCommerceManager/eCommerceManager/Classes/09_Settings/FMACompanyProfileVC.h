//
//  FMACompanyProfileVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/30/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FMADeliveryMethodsView.h"
#import "FMAEditProfileVC.h"
#import "FMABackgroundUtil.h"

@interface FMACompanyProfileVC : UIViewController<FMAEditProfileVCDelegate, FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    UIView           *viewBack1;
@property (weak,    nonatomic)      IBOutlet    UIView           *viewBack2;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    PFImageView      *imageviewCompanyLogo;
@property (weak,    nonatomic)      IBOutlet    UILabel          *labelName;
@property (weak,    nonatomic)      IBOutlet    UILabel          *labelStreet;
@property (weak,    nonatomic)      IBOutlet    UILabel          *labelHoursOperation;
@property (weak,    nonatomic)      IBOutlet    UILabel          *labelPhoneNumber;
@property (weak,    nonatomic)      IBOutlet    FMADeliveryMethodsView *deliveryMethodsView;

@end
