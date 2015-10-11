//
//  FMAReceiptVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/27/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAReceiptVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMABackgroundSetting.h"

#define SEGID_CUSTOMERMESSAGE                @"SEGID_CustomerMessage"

@interface FMAReceiptVC ()

@end

@implementation FMAReceiptVC

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAReceiptVC) return;
    
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
    [self initDataSource];
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
    [self initRatingView];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:_backgroundName toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:_backgroundName delegate:self];

    _txtviewComment.backgroundColor = RGBHEX(0x00121e, .3f);
    [FMAThemeManager setBorderToView:_txtviewComment width:.5f Color:RGBHEX(0xffffff, .3f)];
}

- (void)initRatingView
{
    [self printLogWith:@"initRatingView"];
    
    self.labelRatingViewBack.backgroundColor = [UIColor clearColor];
    
    self.ratingview          = [FMAUtil initRatingViewWithFrame:self.labelRatingViewBack.frame];
    self.ratingview.delegate = self;
    
    [self.view addSubview:self.ratingview];
    
    self.ratingview.userInteractionEnabled = NO;
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    self.navigationItem.prompt = [self promptStringFromOrder:_order];
    
    self.ratingview.value   = [_order[kFMOrderReviewRateKey] floatValue];
    _txtviewComment.text    = _order[kFMOrderReviewCommentKey];
    _labelTotalPrice.text   = [NSString stringWithFormat:@"$%.2f", [_order[kFMOrderTotalPriceKey] floatValue]];
}

- (NSString *)promptStringFromOrder:(PFObject *)order
{
    NSString *res = [NSString stringWithFormat:@"Paid on %@ from %@",
                     [FMAUtil stringFromDate:order.createdAt WithFormat:@"MMM dd, yyyy"],
                     order[kFMOrderCustomerKey][kFMUserFirstNameKey]];
    return res;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMABackgroundUtil requestBackgroundForName:_backgroundName delegate:self];
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_CUSTOMERMESSAGE])
    {
        FMACustomerMessageVC *vc = [FMAUtil vcFromSegue:segue];
        vc.other = _order[kFMOrderCustomerKey];
        
        [FMAUtil appDelegate].currentMessageVC = vc;
        
        vc.backgroundName = _backgroundName;
    }
}

// ------------------------------------------------------------------------------------------------------------------------
#pragma mark - RatingViewDelegate
- (void)rateChanged:(RatingView *)sender
{
    [self printLogWith:@"rateChanged"];
    [self printLogWith:[NSString stringWithFormat:@"%.2f", sender.value]];
}

@end
