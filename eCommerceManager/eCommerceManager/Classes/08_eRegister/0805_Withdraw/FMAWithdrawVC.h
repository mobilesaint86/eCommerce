//
//  FMAWithdrawVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/30/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMAChooseBankVC.h"
#import "FMABackgroundUtil.h"
#import "MBProgressHUD.h"

@class FMAWithdrawVC;
// -----------------------------------------------------------------------------------------
// FMAWithdrawVCDelegate Protocol
// -----------------------------------------------------------------------------------------
@protocol FMAWithdrawVCDelegate <NSObject>

- (void)withdrawVC:(FMAWithdrawVC *)controller didWithdrawAmount:(CGFloat)withdrawAmount;

@end

// ----------------------------------------------------------------------------------
// FMAWithdrawVC Class
// ----------------------------------------------------------------------------------
@interface FMAWithdrawVC : UITableViewController<UITextFieldDelegate, FMAChooseBankVCDelegate, FMABackgroundUtilDelegate>

// -----------------------------------------------------------------------------------------
@property (weak, nonatomic)     id<FMAWithdrawVCDelegate> delegate;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      MBProgressHUD   *hud;

// ----------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

@property (strong,  nonatomic)      FMABank *bank;

// ----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet    UILabel        *labelBank;
@property (weak, nonatomic) IBOutlet    UITextField    *txtAmount;
@property (weak, nonatomic) IBOutlet    UILabel        *labelBalance;

@end
