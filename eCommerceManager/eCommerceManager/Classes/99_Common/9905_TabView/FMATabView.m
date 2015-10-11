//
//  FMATabView.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/22/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMATabView.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAThemeManager.h"
#import "FMAUtil.h"

#define COLOR_NORMAL            RGBHEX(0xffffff, 1.f)
#define COLOR_SELECTED          RGBHEX(0x82befb, 1.f)

@implementation FMATabView

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMATabView) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self printLogWith:@"initWithCoder"];
    
    if ((self = [super initWithCoder:aDecoder]))
    {
        _selectedIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
}

- (void)awakeFromNib
{
    [self printLogWith:@"awakeFromNib"];
    [super awakeFromNib];
    
    [self initUI];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    if (!_colorNormal)
    {
        _colorNormal = COLOR_NORMAL;
    }
    if (!_colorSelected)
    {
        _colorSelected = COLOR_SELECTED;
    }
    
    [self initTheme];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    for (NSInteger i=0; i<_labelButtonContainers.count; i++)
    {
        [_labelButtonContainers[i] setBackgroundColor:_colorNormal];
    }
}

- (void)setButtonThemeByIndex:(NSInteger)index isSelected:(BOOL)bSelected
{
    [self printLogWith:@"setButtonThemeByIndex"];
    
    if (index == -1) return;
    
    UILabel *label        = [self.labelButtonContainers objectAtIndex:index];
    label.backgroundColor = bSelected ? _colorSelected : _colorNormal;
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Setter and Getter
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    [self printLogWith:@"setSelectedIndex"];
    
    [self setButtonThemeByIndex:_selectedIndex isSelected:NO];
    
    _selectedIndex = selectedIndex;
    
    [self setButtonThemeByIndex:_selectedIndex isSelected:YES];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events
- (IBAction)onBtnClicked:(id)sender
{
    [self printLogWith:@"onBtnClicked"];
    
    for (NSInteger i=0; i<self.btnButtons.count; i++)
    {
        if (self.btnButtons[i] == sender && _selectedIndex != i)
        {
            [self setSelectedIndex:i];
            [self.delegate tabView:self didSelectItemAtIndex:i];
        }
    }
}

@end
