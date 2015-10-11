//
//  FMAPayrollVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/25/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FMABackgroundUtil.h"

@interface FMAPayrollVC : UIViewController<FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)     IBOutlet    PFImageView      *imageviewEmployee;
@property (weak,    nonatomic)     IBOutlet    UIView           *viewBack1;

@end
