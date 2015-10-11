//
//  FMAEditBackgroundsCVCell.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/31/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAEditBackgroundsCVCell.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"

@implementation FMAEditBackgroundsCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAEditBackgroundsCVCell) return;
    
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

    _labelTitle.text = data[kFMBackgroundNameKey];
    
    _imageview.image = nil;
    _imageview.file = data[kFMBackgroundImageKey];
    [_imageview loadInBackground];
}

- (void)initTheme
{
    [FMAThemeManager setBorderToView:_labelBack width:1.f Color:RGBHEX(0x747376, 1.f)];
}

@end
