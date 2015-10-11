//
//  FMASecurityCamerasCVCell.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/25/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMASecurityCamerasCVCell.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"

@implementation FMASecurityCamerasCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMASecurityCamerasCVCell) return;
    
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
}

- (void)initTheme
{    
    [FMAThemeManager setBorderToView:self width:1.f Color:[UIColor whiteColor]];
    
    [FMAThemeManager makeCircleWithView:_btnPlay
                            borderColor:RGBHEX(0xffffff, 1.f)
                            borderWidth:COMMON_WIDTH_FOR_CIRCLE_BORDER];
}

@end
