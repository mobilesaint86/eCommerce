//
//  FMAChooseBankVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/30/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMABank.h"
#import "FMABackgroundUtil.h"

@class FMAChooseBankVC;
// ----------------------------------------------------------------------------------------
// FMAChooseBankVCDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMAChooseBankVCDelegate <NSObject>

- (void)chooseBankVC:(FMAChooseBankVC *)controller didSelectBank:(FMABank *)bank;

@end

// ----------------------------------------------------------------------------------------
// FMAChooseBankVC Class
// ----------------------------------------------------------------------------------------
@interface FMAChooseBankVC : UITableViewController<FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      NSString    *backgroundName;
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------------
@property (weak,      nonatomic)   id<FMAChooseBankVCDelegate> delegate;

@end
