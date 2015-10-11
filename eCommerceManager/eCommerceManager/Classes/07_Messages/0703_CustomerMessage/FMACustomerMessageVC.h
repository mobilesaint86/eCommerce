//
//  FMACustomerMessageVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/26/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessages.h"
#import "MBProgressHUD.h"
#import "FMACustomerMessageUtil.h"
#import "FMABackgroundUtil.h"

@interface FMACustomerMessageVC : JSQMessagesViewController<FMACustomerMessageUtilDelegate, FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;
@property (strong, 	nonatomic)      NSString    *backgroundName;

// ----------------------------------------------------------------------------------
@property (strong, nonatomic) NSTimer           *timer;
@property (nonatomic)         BOOL              bRegularLoading;
@property (nonatomic)         BOOL              bTimerLoading;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      MBProgressHUD *hud;
@property (strong,  nonatomic)      UILabel       *labelEmpty;
@property (strong,  nonatomic)      PFUser        *other;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)     IBOutlet    UIButton         *btnCustomerAvatar;
@property (weak,    nonatomic)     IBOutlet    UIButton         *btnReceiver;

// --------------------------------------------------------------------------------------
// Test Models Related Methods and Variables
// --------------------------------------------------------------------------------------
@property (strong, nonatomic) NSMutableArray *messages;
@property (copy,   nonatomic) NSDictionary   *avatars;

@property (strong, nonatomic) UIImageView    *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView    *incomingBubbleImageView;

- (void)setupTestModel;

@end
