//
//  FMABrowseCVCell.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/20/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMABrowseCVCell.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMABrowseUtil.h"
#import "TTTTimeIntervalFormatter.h"
#import "FMAUserSetting.h"

static TTTTimeIntervalFormatter *timeFormatter;

@implementation FMABrowseCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMABrowseCVCell) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (void)setSelected:(BOOL)selected
{
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data
{
    [self printLogWith:@"configureCellWithData"];
    
    [self initTheme];
    
    PFObject *product = (PFObject *)data;
    
    _textviewTitle.text = product[kFMProductTitleKey];
    _labelTitle.text    = product[kFMProductTitleKey];
    _labelPrice.text = [NSString stringWithFormat:@"$%.2f", [product[kFMProductPriceKey] floatValue]];
    
    if ([FMAUtil isObjectEmpty:product[kFMProductShippingRate]] ||
        [product[kFMProductShippingRate] floatValue] == 0.f)
    {
        _labelShippingRate.text = @"FREE";
    }
    else
    {
        _labelShippingRate.text = [NSString stringWithFormat:@"+$%.2f", [product[kFMProductShippingRate] floatValue]];
    }
    
    _imageviewProduct.image = nil;
    _imageviewProduct.file = [product[kFMProductImagesKey] objectAtIndex:0];
    [_imageviewProduct loadInBackground];
    
    if (!timeFormatter)
    {
        timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }
    
    FMAUserSetting *settings = [FMAUserSetting sharedInstance];
    
    if (settings.browseMode == FMA_BROWSE_MODE_GRID ||
        settings.browseMode == FMA_BROWSE_MODE_LINE)
    {
        _labelPostedPeriod.text = [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:product.createdAt];
    }
    else
    {
        _labelPostedPeriod.text = [NSString stringWithFormat:@"posted: %@",
                                   [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:product.createdAt]];
    }
    
    [FMABrowseUtil setDistanceLabel:_labelDistance inViewModeGrid:settings.browseMode forProduct:product];
}

- (void)initTheme
{
    _imageviewProduct.contentMode = UIViewContentModeScaleAspectFill;
    _imageviewProduct.clipsToBounds = YES;
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnShare:(id)sender
{
    [self printLogWith:@"onBtnShare"];
    
    [self.delegate browseCVCellDidClickShare:self];
}

@end
