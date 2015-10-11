//
//  FMAWeekdayPickerView.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/31/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAWeekdayPickerView.h"
#import "FMAData.h"
#import "FMAUtil.h"

const CGRect defaultRect = {{0, 0}, {320, 250}};

@implementation FMAWeekdayPickerView
{
    NSArray *dataSource;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAWeekdayPickerView) return;
    
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

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - View Functions
- (instancetype)initWithFrame:(CGRect)frame
{
    [self printLogWith:@"initWithFrame"];
    
    if (CGRectIsEmpty(frame))
    {
        self = [super initWithFrame:defaultRect];
    }
    else
    {
        self = [super initWithFrame:frame];
    }
    
    if (self)
    {
        dataSource = @[@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday"];
        
        self.dataSource = self;
        self.delegate   = self;
    }
    return self;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (NSString *)titleAtRow:(NSInteger)row
{
    if (row < [dataSource count])
    {
        return [dataSource objectAtIndex:row];
    }
    return @"";
}

- (NSInteger)indexOfWeekday:(NSString *)weekday
{
    return [dataSource indexOfObject:weekday];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - UIPickerView Delegate Functions
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataSource count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self titleAtRow:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_weekdayPickerViewDelegate weekdaysPickerView:self didSelectWeekday:[self titleAtRow:row]];
}

@end
