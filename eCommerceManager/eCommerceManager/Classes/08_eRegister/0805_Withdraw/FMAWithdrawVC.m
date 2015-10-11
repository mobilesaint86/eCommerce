//
//  FMAWithdrawVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/30/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAWithdrawVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMABackgroundSetting.h"
#import "FMAUserSetting.h"
#import "FMAERegisterUtil.h"
#import "Stripe.h"

#define SEGID_CHOOSE_BANK       @"SEGID_ChooseBank"

@interface FMAWithdrawVC ()

@end

@implementation FMAWithdrawVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAWithdrawVC) return;
    
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

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
    [self initContents];
}

- (void)viewDidLayoutSubviews
{
    [self printLogWith:@"viewDidLayoutSubviews"];
    [super viewDidLayoutSubviews];
    
    [FMAThemeManager relayoutTableviewForApp:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [self printLogWith:@"didReceiveMemoryWarning"];
    [super didReceiveMemoryWarning];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initTheme];
    
    [self initTextFieldsPlaceholder];
    
    [self setupInputAccessoryViews];
    
    _hud = [FMAUtil initHUDWithView:self.view];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    [self initViewBackground];
}

- (void)setupInputAccessoryViews
{
    [self printLogWith:@"setupInputAccessoryViews"];
    
    [FMAUtil setupInputAccessoryViewWithPrevNextHideButtonsForControl:_txtAmount
                                                           withTarget:self
                                            selectorForPreviousButton:nil
                                                selectorForNextButton:nil
                                                selectorForDoneButton:nil];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameERegister toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameERegister delegate:self];
}

- (void)initTextFieldsPlaceholder
{
    [self printLogWith:@"initTextFieldsPlaceholder"];
    
    [FMAThemeManager setPlaceholder:@"0.00"       toTextField:_txtAmount   color:[UIColor whiteColor]];
}

- (void)initContents
{
    [self printLogWith:@"initContents"];
    
    self.txtAmount.text = @"";
    
    [self updateLabelBalance];
    
    self.labelBank.text = @"";
}

- (void)updateLabelBalance
{
    [self printLogWith:@"updateLabelBalance"];
    
    CGFloat remainingAmount = [self remainingAmount];
    
    self.labelBalance.text  = [NSString stringWithFormat:@"Balance: $%.2f", remainingAmount];
}

- (CGFloat)withdrawAmount
{
    [self printLogWith:@"withdrawAmount"];
    
    CGFloat res=0.f;
    
    if (![FMAUtil isStringEmpty:self.txtAmount.text])
    {
        res = [self.txtAmount.text floatValue];
    }
    return res;
}

- (CGFloat)remainingAmount
{
    [self printLogWith:@"remainingAmount"];
    
//
    [FMAERegisterUtil totalAmountFromBalance:[[FMAUserSetting sharedInstance] balance]];
    CGFloat totalBalance      = [[[FMAUserSetting sharedInstance] balance][kFMBalanceAvailableKey] floatValue];
    CGFloat withdrawingAmount = [self withdrawAmount];
    
    CGFloat res = totalBalance - withdrawingAmount;
    
    return res;
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

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnWithdraw:(id)sender
{
    [self printLogWith:@"onBtnWithdraw"];
    
    if (![self doValidationProcess])
    {
        return;
    }
    
    [self doCreateToken];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_CHOOSE_BANK])
    {
        FMAChooseBankVC *vc = [FMAUtil vcFromSegue:segue];
        vc.delegate         = self;
        vc.backgroundName   = kFMBackgroundNameERegister;
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMAChooseBankVCDelegate
- (void)chooseBankVC:(FMAChooseBankVC *)controller didSelectBank:(FMABank *)bank
{
    [self printLogWith:@"chooseBankVC: didSelectBank"];
    
    _bank = bank;
    _labelBank.text = [bank displayTitle];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TableView Delegate Functions
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"tableView didSelectRowAtIndexPath"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2)
    {
        [self performSegueWithIdentifier:SEGID_CHOOSE_BANK sender:self];
    }
    
    if (indexPath.row == 4)
    {
        [_txtAmount becomeFirstResponder];
    }
    
    if (indexPath.row == 7)
    {
        [self onBtnWithdraw:nil];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.txtAmount)
    {
        if (![FMAUtil checkAndFormatDecimalNumberField:textField shouldChangeCharactersInRange:range replacementString:string])
        {
            return NO;
        }
    }
    return YES;
}

- (IBAction)textFieldDidChange:(id)sender
{
    [self updateLabelBalance];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)checkAllFieldsExist
{
    [self printLogWith:@"checkAllFieldsExist"];
    
    NSArray *infoFields = @[@{kFMAValidationPlaceholderKey:@"0.00 USD",
                              kFMAValidationControlKey: self.txtAmount},
                            ];
    
    return [FMAUtil checkAllFieldsExist:infoFields];
}

- (BOOL)doValidationProcess
{
    [self printLogWith:@"doValidationProcess"];
    
    if (![self checkAllFieldsExist])
    {
        [[FMAUtil generalAlertWithTitle:nil message:ALERT_MSG_FIELDS_EMPTY delegate:self]show];
        return NO;
    }
    
    if ([FMAUtil isObjectEmpty:_bank])
    {
        [[FMAUtil generalAlertWithTitle:nil message:@"Please choose a bank to withdraw." delegate:self]show];
        return NO;
    }
    
    if ([self withdrawAmount] == 0)
    {
        [[FMAUtil generalAlertWithTitle:nil message:@"Please fill in the amount to withdraw." delegate:self]show];
        return NO;
    }
    
    if ([self remainingAmount] < 0)
    {
        [[FMAUtil generalAlertWithTitle:nil message:@"Please adjust the withdrawal amount to keep the balance." delegate:self]show];
        return NO;
    }
    
    return YES;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Withdrawing Functions
- (void)doCreateToken
{
    [self printLogWith:@"doCreateToken"];
    
    [FMAUtil showHUD:self.hud withText:@"Validating..."];
    
    [Stripe createTokenWithBank:_bank
                 publishableKey:[FMAUtil stripePublishableKey]
                     completion:^(STPToken *token, NSError *error)
     {
         if (error)
         {
             [self.hud hide:YES];
             [[FMAUtil generalAlertWithTitle:ALERT_TITLE_ERROR message:[error localizedDescription] delegate:nil] show];
         }
         else
         {
             [self doWithdrawWithToken:token];
         }
     }];
}

- (void)doWithdrawWithToken:(STPToken *)token
{
    [self printLogWith:@"doWithdrawWithToken"];
    
    [FMAUtil showHUD:self.hud withText:@"Withdrawing..."];
    
    NSDictionary *params = [self requestParamsWithToken:token];
    
    [PFCloud callFunctionInBackground:@"withdrawBalance"
                       withParameters:params
                                block:^(id object, NSError *error)
     {
         [self.hud hide:YES];
         
         if (error)
         {
             [[FMAUtil generalAlertWithTitle:ALERT_TITLE_ERROR
                                    message:[FMAUtil errorStringFromParseError:error WithCode:NO]
                                   delegate:nil] show];
         }
         else
         {
             [_delegate withdrawVC:self didWithdrawAmount:[self withdrawAmount]];
         }
     }];
}

- (NSDictionary *)requestParamsWithToken:(STPToken *)token
{
    [self printLogWith:@"requestParams"];
    
    NSDictionary *res = @{
                          @"withdrawAmount": @([self.txtAmount.text floatValue]),
                          @"bankToken": token.tokenId,
                          };
    
    return res;
}

@end
