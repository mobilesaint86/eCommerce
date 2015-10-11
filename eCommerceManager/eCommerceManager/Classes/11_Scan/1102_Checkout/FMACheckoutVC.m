//
//  FMACheckoutVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/4/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMACheckoutVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMAScanUtil.h"
#import "FMACheckoutUtil.h"
#import "FMABackgroundSetting.h"

#define CELLID_CHECKOUTPRODUCT                  @"CheckoutProductCell"
#define CELLID_CHECKOUTBOTTOM                   @"CheckoutBottom"

#define TAG_SUBTOTAL                            301
#define TAG_TAX                                 302
#define TAG_SHIPPING                            303
#define TAG_GRANDTOTAL                          304

@interface FMACheckoutVC ()

@end

@implementation FMACheckoutVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMACheckoutVC) return;
    
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
    
    _hud = [FMAUtil initHUDWithView:self.view];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    [self initViewBackground];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:_backgroundName toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:_backgroundName delegate:self];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMAThemeManager setBackgroundImageForName:_backgroundName toImageView:_imageviewBackground];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [_delegate checkoutVCDidCancel];
}

- (IBAction)onBtnSwipeCard:(id)sender
{
    [self printLogWith:@"onBtnSwipeCard"];
    
    if (![self doValidationProcess]) return;
    
    if (_pk_card)
    {
        [self doCheckout];
    }
    else
    {
        CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
        [scanViewController setUseCardIOLogo:YES];
        
        [scanViewController setCollectCVV:YES];
        [scanViewController setCollectExpiry:YES];
        [scanViewController setCollectPostalCode:YES];
        
        scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:scanViewController animated:YES completion:^{
            //[FBThemeManager setNavigationBarThemeToObject:[scanViewController navigationBar]];
        }];
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - FMACheckoutProductCellDelegate
- (id)checkoutProductCellGetPrdouctData:(FMACheckoutProductCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    return [self objectAtIndexPath:indexPath];
}

- (void)checkoutProductCell:(FMACheckoutProductCell *)cell didUpdateQuantity:(int)quantity
{
    [self printLogWith:@"checkoutProductCell: didUpdateQuantity"];
    
    NSMutableDictionary *data = [self checkoutProductCellGetPrdouctData:cell];
    data[kFMCartQuantityKey]  = [NSNumber numberWithInt:quantity];
    
    [self initBottomCell];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Bottom Cell Function
- (void)initBottomCell
{
    [self printLogWith:@"initBottomCell"];
    
    _labelSubTotal.text     = [NSString stringWithFormat:@"%.2f", [FMACheckoutUtil subTotalPriceFromCart:_cart]];
    _labelShipping.text     = [NSString stringWithFormat:@"%.2f", 0.f];
    _labelTax.text          = [NSString stringWithFormat:@"%.2f", [FMACheckoutUtil salesTaxFromCart:_cart]];
    _labelGrandTotal.text   = [NSString stringWithFormat:@"%.2f", [FMACheckoutUtil grandTotalPriceFromCart:_cart]];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - UITableView Delegate
- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return _cart[indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [_cart count];
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 100;
    }
    return 240;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *res;
    
    if (indexPath.section == 0)
    {
        FMACheckoutProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID_CHECKOUTPRODUCT];
        
        [cell configureCellWithData:[self objectAtIndexPath:indexPath]];
        
        res = cell;
    }
    else
    {
        res = [tableView dequeueReusableCellWithIdentifier:CELLID_CHECKOUTBOTTOM];
        
        _labelSubTotal   = (UILabel *)[res viewWithTag:TAG_SUBTOTAL];
        _labelShipping   = (UILabel *)[res viewWithTag:TAG_SHIPPING];
        _labelTax        = (UILabel *)[res viewWithTag:TAG_TAX];
        _labelGrandTotal = (UILabel *)[res viewWithTag:TAG_GRANDTOTAL];
        
        [self initBottomCell];
    }
    
    return res;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"tableView: didSelectRowAtIndexPath"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - CardIOPaymentViewControllerDelegate
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    [self printLogWith:@"userDidCancelPaymentViewController"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    [self printLogWith:@"userDidProvideCreditCardInfo"];
    
    PKCard *card    = [[PKCard alloc] init];
    card.number     = info.cardNumber;
    card.cvc        = info.cvv;
    card.expMonth   = info.expiryMonth;
    card.expYear    = info.expiryYear;
    card.addressZip = info.postalCode;
    
    _pk_card        = card;
    
    [self doCheckout];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Charging Functions
- (void)doCheckout
{
    [self printLogWith:@"doCheckout"];
    
    [FMAUtil showHUD:self.hud withText:@"Authorizing..."];
    
    STPCard *card = [[STPCard alloc] init];
    card.number   = self.pk_card.number;
    card.expMonth = self.pk_card.expMonth;
    card.expYear  = self.pk_card.expYear;
    card.cvc      = self.pk_card.cvc;
    
    [Stripe createTokenWithCard:card
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
             [self doChargeWithToken:token];
         }
     }];
}

- (void)doChargeWithToken:(STPToken *)token
{
    [self printLogWith:@"doChargeWithToken"];
    [FMAUtil showHUD:self.hud withText:@"Charging..."];
    
    NSDictionary *params = [self requestParamsWithToken:token];
    
    [PFCloud callFunctionInBackground:@"managerCheckOutProductsWithParams"
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
             [self.delegate checkoutVCDidSucceed];
         }
     }];
}

- (NSDictionary *)requestParamsWithToken:(STPToken *)token
{
    [self printLogWith:@"requestParams"];
    
    NSDictionary *res = @{
                          @"cardToken":     token.tokenId,
                          @"cart" :         [FMACheckoutUtil cartRequestParamFromCart:_cart],
                          @"totalPrice":    @([FMACheckoutUtil grandTotalPriceFromCart:_cart]),
                          @"salesTax":      @([FMACheckoutUtil salesTaxFromCart:_cart]),
                          };
    
    return res;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Validation Functions
- (BOOL)doValidationProcess
{
    [self printLogWith:@"doValidationProcess"];
    
    // Check if cart is empty
    if ([_cart count] ==0)
    {
        NSString *msg = @"No products to check out. Please scan products you want to order.";
        [[FMAUtil generalAlertWithTitle:ALERT_TITLE_WARNING message:msg delegate:self] show];
        
        return NO;
    }
    
    // Check if an order is out of stock or an ordered quantity is zero
    for (int i=0; i<[_cart count]; i++)
    {
        PFObject *product = [_cart[i] objectForKey:kFMCartProductKey];
        
        int stock = [product[kFMProductQuantityKey] intValue];
        
        int orderedQuantity = [[_cart[i] objectForKey:kFMCartQuantityKey] intValue];
        
        if (orderedQuantity <= 0)
        {
            NSString *msg = @"The order quantity should not be zero. Please fix it and try again.";
            [[FMAUtil generalAlertWithTitle:ALERT_TITLE_WARNING message:msg delegate:self] show];
            
            return NO;
        }
        
        if (orderedQuantity > stock)
        {
            NSString *msgFormat = @"The current stock of product: %@ is %d. Please fix it and try again.";
            NSString *msg       = [NSString stringWithFormat:msgFormat, product[kFMProductTitleKey], [product[kFMProductQuantityKey] intValue]];
            
            [[FMAUtil generalAlertWithTitle:ALERT_TITLE_WARNING message:msg delegate:self] show];
            
            return NO;
        }
    }
    
    return YES;
}

@end
