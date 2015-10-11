//
//  FMAEmployeesCVCell.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/25/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAEmployeesCVCell.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"

@implementation FMAEmployeesCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAEmployeesCVCell) return;
    
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
    
    _labelName.text = data[kFMUserFirstNameKey];
}

- (void)initTheme
{
    [FMAThemeManager makeCircleWithView:_imageviewEmployee
                            borderColor:RGBHEX(0xffffff, 1.f)
                            borderWidth:COMMON_WIDTH_FOR_CIRCLE_BORDER];
}

@end
