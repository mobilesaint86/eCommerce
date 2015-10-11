//
//  FMAMessagesVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/26/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMAMessageBoardVC.h"
#import "REFrostedViewController.h"
#import "FMABackgroundUtil.h"

@interface FMAMessagesVC : UIViewController<FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)     IBOutlet    UIView           *viewBack1;
@property (weak,    nonatomic)     IBOutlet    UIView           *viewBack2;
@property (weak,    nonatomic)     IBOutlet    UIView           *viewBack3;

@end
