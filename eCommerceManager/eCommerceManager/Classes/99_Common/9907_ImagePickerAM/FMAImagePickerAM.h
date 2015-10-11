//
//  FMAImagePickerAM.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/31/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGEPICKER_MENU_ITEM_TAKE_PHOTO        @"Take Photo"
#define IMAGEPICKER_MENU_ITEM_FROM_CAMERAROLL   @"Import From Camera Roll"

// -------------------------------------------------------------------------------------
// FMAImagePickerAMDelegate Protocol
// -------------------------------------------------------------------------------------
@protocol FMAImagePickerAMDelegate <NSObject>

- (void)imagePickerAMClickedMenuItemTitle:(NSString *)menuItemTitle;

@end

// -------------------------------------------------------------------------------------
// FMAImagePickerAM Class
// -------------------------------------------------------------------------------------
@interface FMAImagePickerAM : UIActionSheet<UIActionSheetDelegate>

// -------------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMAImagePickerAMDelegate> amdelegate;

// -------------------------------------------------------------------------------------
#pragma mark - Functions
- (id)initActionMenu;
- (void)showActionMenu;

@end
