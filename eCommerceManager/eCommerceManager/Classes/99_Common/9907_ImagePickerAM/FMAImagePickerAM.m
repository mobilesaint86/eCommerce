//
//  FMAImagePickerAM.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/31/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAImagePickerAM.h"
#import "FMAData.h"

#define MENU_TITLE                  @"Choose Image"
#define MENU_ITEM_CANCEL            @"Cancel"

@implementation FMAImagePickerAM

// ------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAImagePickerAM) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
}

// ------------------------------------------------------------------------------------------------------------------------
#pragma mark - Init Functions
- (id)initActionMenu
{
    [self printLogWith:@"initActionMenu"];
    
    self = [super initWithTitle:MENU_TITLE
                       delegate:self
              cancelButtonTitle:nil
         destructiveButtonTitle:nil
              otherButtonTitles:nil];
    
    if (self != nil)
    {
        [self initMenuItems];
    }
    
    return self;
}

- (void)initMenuItems
{
    [self printLogWith:@"initMenuItems"];
    
    NSArray *menuItems = @[IMAGEPICKER_MENU_ITEM_TAKE_PHOTO,
                           IMAGEPICKER_MENU_ITEM_FROM_CAMERAROLL,
                           MENU_ITEM_CANCEL];
    
    for (NSString *itemTitle in menuItems)
    {
        [self addButtonWithTitle:itemTitle];
    }
    
    self.cancelButtonIndex = self.numberOfButtons - 1;
}

// ------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (UIView *)viewFromDelegate
{
    return ((UIViewController*)self.amdelegate).view;
}

- (UIViewController *)viewControllerFromDelegate
{
    return (UIViewController*)self.amdelegate;
}

- (void)showActionMenu
{
    [self printLogWith:@"showActionMenu"];
    
    [self showInView:[self viewFromDelegate]];
}

// ------------------------------------------------------------------------------------------------------------------------
#pragma mark - UIActionSheetDelegate
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    [self printLogWith:@"dismissWithClickedButtonIndex"];
    
    NSString *buttonTitle = [self buttonTitleAtIndex:buttonIndex];
    
    [self printLogWith:@"dismissWithClickedButtonIndex:"];
    [self printLogWith:buttonTitle];
    
    if ([buttonTitle isEqualToString:MENU_ITEM_CANCEL])
    {
        [self printLogWith:@"dismissWithClickedButtonIndex: 'Cancel' Button Clicked"];
    }
    else
    {
        [self printLogWith:@"dismissWithClickedButtonIndex: '%@' Button Clicked"];
        [self.amdelegate imagePickerAMClickedMenuItemTitle:buttonTitle];
    }
    
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

@end
