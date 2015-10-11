//
//  FMAERegisterVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/27/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAERegisterVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMABackgroundSetting.h"
#import "FMAUserSetting.h"
#import "FMAWithdrawVC.h"

#define SEGID_ADDBANK                       @"SEGID_AddBank"
#define SEGID_ADDCARD                       @"SEGID_AddCard"
#define SEGID_WITHDRAW                      @"SEGID_Withdraw"

@interface FMAERegisterVC ()

@end

@implementation FMAERegisterVC

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAERegisterVC) return;
    
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
    [self initBalance];
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
    [self initNameLabel];
    
    [FMAThemeManager makeCircleWithView:_imageviewAvatar
                            borderColor:RGBHEX(0xffffff, 1.f)
                            borderWidth:COMMON_WIDTH_FOR_CIRCLE_BORDER];
    
    _bankListView.delegate = self;
    _cardListView.delegate = self;
    
    _hud = [FMAUtil initHUDWithView:self.view];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameERegister toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameERegister delegate:self];
    
    _viewBack1.backgroundColor      = [UIColor clearColor];
    
    _bankListView.backgroundColor   = [UIColor clearColor];
    _cardListView.backgroundColor   = [UIColor clearColor];
}

- (void)initNameLabel
{
    [self printLogWith:@"initNameLabel"];
    
    _labelName.text = [PFUser currentUser][kFMUserFirstNameKey];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameERegister toImageView:_imageviewBackground];
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Balance Functions
- (void)initBalance
{
    [self printLogWith:@"initBalance"];
    
    [FMAUtil showHUD:_hud withText:@""];
    
    [self updateBalanceLabel];
    
    [FMAERegisterUtil requestGetBalance:self];
}

- (void)updateBalanceLabel
{
    [self printLogWith:@"updateBalanceLabel"];
    
    NSDictionary *balance = [[FMAUserSetting sharedInstance] balance];
    
    _labelTotalBalance.text     = [NSString stringWithFormat:@"$%.2f",[FMAERegisterUtil totalAmountFromBalance:balance]];
    _labelAvailableBalance.text = [NSString stringWithFormat:@"$%.2f",[balance[kFMBalanceAvailableKey] floatValue]];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAERegisterUtilDelegate
- (void)eRegisterUtilDelegateHideHud
{
    [self printLogWith:@"eRegisterUtilDelegateHideHud"];
    
    if (_hud)
    {
        [_hud hide:YES];
    }
}

- (void)requestGetBalanceDidRespondWithBalance:(NSDictionary *)balance
{
    [self printLogWith:@"requestGetBalanceDidRespondWithBalance"];
    [_hud hide:YES];
    
    FMAUserSetting *userSetting = [FMAUserSetting sharedInstance];
    userSetting.balance = [[NSMutableDictionary alloc] initWithDictionary:balance];
    [userSetting store];
    
    [self updateBalanceLabel];
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
    
    if ([segue.identifier isEqualToString:SEGID_ADDBANK])
    {
        FMAAddBankVC *vc = [FMAUtil vcFromSegue:segue];
        vc.delegate      = self;
        vc.backgroundName = kFMBackgroundNameERegister;
    }
    
    if ([segue.identifier isEqualToString:SEGID_ADDCARD])
    {
        FMAAddCardVC *vc = [FMAUtil vcFromSegue:segue];
        vc.delegate      = self;
        vc.backgroundName = kFMBackgroundNameERegister;
    }
    
    if ([segue.identifier isEqualToString:SEGID_WITHDRAW])
    {
        FMAWithdrawVC *vc = [FMAUtil vcFromSegue:segue];
        vc.delegate = self;
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABankListViewDelegate
- (void)bankListViewDidClickAddButton
{
    [self printLogWith:@"bankListViewDidClickAddButton"];
    
    [self performSegueWithIdentifier:SEGID_ADDBANK sender:self];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAAddBankVCDelegate
- (void)addBankVC:(FMAAddBankVC *)controller didSaveBank:(FMABank *)bank
{
    [self printLogWith:@"addBankVC didSaveBank"];
    
    [self.bankListView addBank:bank];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMACardListViewDelegate
- (void)cardListViewDidClickAddButton
{
    [self printLogWith:@"cardListViewDidClickAddButton"];
    
    [self performSegueWithIdentifier:SEGID_ADDCARD sender:self];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAAddCardVCDelegate
- (void)addCardVC:(FMAAddCardVC *)controller didSaveCard:(PKCard *)card
{
    [self printLogWith:@"addCardVC: didSaveCard"];
    
    [self.cardListView addCard:card];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAWithdrawVCDelegate
- (void)withdrawVC:(FMAWithdrawVC *)controller didWithdrawAmount:(CGFloat)withdrawAmount
{
    [self printLogWith:@"withdrawVC: didWithdrawAmount"];
    
    [FMAERegisterUtil requestGetBalance:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
