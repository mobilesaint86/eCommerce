//
//  FMAPriceRangeVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/20/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAPriceRangeVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAUserSetting.h"

@interface FMAPriceRangeVC ()

@end

@implementation FMAPriceRangeVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAPriceRangeVC) return;
    
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
    
    [self updateLabels];
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
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self initSlider];
}

- (void)initSlider
{
    [self printLogWith:@"initSlider"];
    
    [FMAUtil setupRangeSlider:self.rangesliderPrice minValue:MIN_PRICE maxValue:MAX_PRICE];
    
    self.rangesliderPrice.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    FMAUserSetting *userSetting = [FMAUserSetting sharedInstance];
    
    _rangesliderPrice.rightValue    = userSetting.price2;
    _rangesliderPrice.leftValue     = userSetting.price1;
    
    [self updateLabels];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Range Slider Change Event
- (IBAction)onPriceRangeSliderChanged:(ACVRangeSelector *)sender
{
    [self printLogWith:@"onPriceRangeSliderChanged"];
    
    [self updateLabels];
    
    FMAUserSetting *userSetting = [FMAUserSetting sharedInstance];
    
    userSetting.price1   = _rangesliderPrice.leftValue;
    userSetting.price2   = _rangesliderPrice.rightValue;
    
    userSetting.bChanged = YES;
}

- (void)updateLabels
{
    [self printLogWith:@"updateLabels"];
    
    self.labelMin.text = [NSString stringWithFormat:@"$%.0f", self.rangesliderPrice.leftValue];
    
    if (self.rangesliderPrice.rightValue >= MAX_PRICE)
    {
        self.labelMax.text = [NSString stringWithFormat:@"$%.0f+", self.rangesliderPrice.rightValue];
    }
    else
    {
        self.labelMax.text = [NSString stringWithFormat:@"$%.0f", self.rangesliderPrice.rightValue];
    }
}

@end
