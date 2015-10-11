//
//  FMAAddCardVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/29/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stripe.h"
#import "PKCard.h"
#import "PKCardNumber.h"
#import "PKCardExpiry.h"
#import "PKCardCVC.h"
#import "PKAddressZip.h"
#import "PKUSAddressZip.h"
#import "PKTextField.h"
#import "CardIO.h"
#import "FMABackgroundUtil.h"

@class FMAAddCardVC;
// ----------------------------------------------------------------------------------
// FMAAddCardVCDelegate Protocol
// ----------------------------------------------------------------------------------
@protocol FMAAddCardVCDelegate <NSObject>

- (void)addCardVC:(FMAAddCardVC *)controller didSaveCard:(PKCard *)card;

@end

// ----------------------------------------------------------------------------------
// FBAddCardVC Class
// ----------------------------------------------------------------------------------
@interface FMAAddCardVC : UITableViewController<UITextFieldDelegate, PKTextFieldDelegate, CardIOPaymentViewControllerDelegate, FMABackgroundUtilDelegate>
{
    UITextField *activeField;
    NSString    *previousTextFieldContent;
    UITextRange *previousSelection;
    BOOL        isUSAddress;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      NSString    *backgroundName;
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic)   id<FMAAddCardVCDelegate> delegate;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet PKTextField  *txtCardNumber;
@property (weak,    nonatomic) IBOutlet PKTextField  *txtExpDate;
@property (weak,    nonatomic) IBOutlet PKTextField  *txtCVC;
@property (weak,    nonatomic) IBOutlet PKTextField  *txtZip;

@end
