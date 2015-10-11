//
//  FMAFilterCategoryCVCell.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/20/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAFilterCategoryCVCell.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"

@implementation FMAFilterCategoryCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAFilterCategoryCVCell) return;
    
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
        _labelTitle.text = data[kFMCategoryNameKey];
    }
}

- (void)initTheme
{
    [FMAThemeManager makeCircleWithView:_btnImage
                            borderColor:RGBHEX(0xffffff, 1.f)
                            borderWidth:COMMON_WIDTH_FOR_CIRCLE_BORDER];
    
    _btnChecked.hidden = YES;
}

@end
