//
//  FMAImageCaptionCVCell.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/20/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAImageCaptionCVCell.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAThemeManager.h"
#import "FMAUtil.h"

@implementation FMAImageCaptionCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAImageCaptionCVCell) return;
    
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
    
    self.labelTitle.text = [data objectForKey:kFMACellDataTitleKey] ? data[kFMACellDataTitleKey] : @"Title";
    
    if ([data objectForKey:kFMACellDataImageIconKey])
    {
        [FMAUtil setImageNamed:[data objectForKey:kFMACellDataImageIconKey] toButton:_btnImage];
    }
}

- (void)initTheme
{
    [FMAThemeManager makeCircleWithView:self.btnImage
                           borderColor:RGBHEX(0xffffff, 1.f)
                            borderWidth:COMMON_WIDTH_FOR_CIRCLE_BORDER];
}

@end
