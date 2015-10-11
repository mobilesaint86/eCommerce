//
//  FMAWeekdayPickerView.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/31/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMAWeekdayPickerView;
// --------------------------------------------------------------------------------------
// FMAWeekdayPickerViewDelegate Protocol
// --------------------------------------------------------------------------------------
@protocol FMAWeekdayPickerViewDelegate <NSObject>

- (void)weekdaysPickerView:(FMAWeekdayPickerView *)pickerView didSelectWeekday:(NSString *)weekday;

@end

// --------------------------------------------------------------------------------------
// FMAWeekdayPickerView Class
// --------------------------------------------------------------------------------------
@interface FMAWeekdayPickerView : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource>

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic) id<FMAWeekdayPickerViewDelegate> weekdayPickerViewDelegate;

// --------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (NSInteger)indexOfWeekday:(NSString *)weekday;

@end
