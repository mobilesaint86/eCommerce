//
//  FMAMessageEmployeesCell.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/26/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAMessageEmployeesCell.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMAMessageEmployeesUtil.h"

@implementation FMAMessageEmployeesCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAMessageEmployeesCell) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
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
    
    [FMAMessageEmployeesUtil setDistanceLabel:_labelDistance withUser:data];
}

- (void)initTheme
{
    [FMAThemeManager makeCircleWithView:_imageviewAvatar
                            borderColor:RGBHEX(0xffffff, 1.f)
                            borderWidth:COMMON_WIDTH_FOR_CIRCLE_BORDER];
    
    self.backgroundColor = [UIColor clearColor];
}

@end
