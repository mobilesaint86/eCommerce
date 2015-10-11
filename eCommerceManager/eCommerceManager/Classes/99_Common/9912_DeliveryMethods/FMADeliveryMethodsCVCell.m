//
//  FMADeliveryMethodsCVCell.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/23/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMADeliveryMethodsCVCell.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"

#define COLOR_SELECTED          RGBHEX(0x9fff9d, .5f)
#define COLOR_NORMAL            RGBHEX(0xff9aaf, .5f)

@implementation FMADeliveryMethodsCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMADeliveryMethodsCVCell) return;
    
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
    
    if (data)
    {
        _labelTitle.text = data[kFMDeliveryMethodNameKey];
    }
}

- (void)initTheme
{
    _labelTitle.backgroundColor = COLOR_NORMAL;
    
    [FMAThemeManager makeCircleWithView:_labelTitle
                            borderColor:nil
                            borderWidth:0.f];
}

- (void)changeColorWithSelected:(BOOL)bSelected
{
    [self printLogWith:@"changeColorWithSelected"];
    
    if (bSelected)
    {
        _labelTitle.backgroundColor = COLOR_SELECTED;
    }
    else
    {
        _labelTitle.backgroundColor = COLOR_NORMAL;
    }
}

@end
