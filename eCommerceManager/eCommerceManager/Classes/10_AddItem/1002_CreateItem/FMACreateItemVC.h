//
//  FMACreateItemVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/2/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMACreateItemImageListView.h"
#import "WYPopoverController.h"
#import "FMAChooseCategoryVC.h"
#import "FMAChooseColorVC.h"
#import "FMAEditPackageDimensionsVC.h"
#import "FMAItemBarcodeScanVC.h"

@class FMACreateItemVC;

// ----------------------------------------------------------------------------------------
// FMACreateItemVCDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMACreateItemVCDelegate <NSObject>

- (NSArray *)createItemVCGetImageList;
- (void)createItemVC:(FMACreateItemVC *)controller didCreateProduct:(PFObject *)product;

@end

// ----------------------------------------------------------------------------------------
// FMACreateItemVC Class
// ----------------------------------------------------------------------------------------
@interface FMACreateItemVC : UITableViewController<UITextFieldDelegate, UITextViewDelegate, FMAChooseCategoryVCDelegate, FMAChooseColorVCDelegate, FMAEditPackageDimensionsVCDelegate, FMAItemBarcodeScanVCDelegate>
{
    id activeField;
}

// ----------------------------------------------------------------------------------------
@property (strong,  nonatomic)  PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic)  id<FMACreateItemVCDelegate> delegate;
@property (strong,  nonatomic)  MBProgressHUD   *hud;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet FMACreateItemImageListView *createItemImageListView;

@property (weak,    nonatomic)  IBOutlet UITextField      *txtTitle;
@property (weak,    nonatomic)  IBOutlet UITextField      *txtBarcode;
@property (weak,    nonatomic)  IBOutlet UITextField      *txtPrice;
@property (weak,    nonatomic)  IBOutlet UITextField      *txtQuantity;
@property (weak,    nonatomic)  IBOutlet UITextView       *txtviewDescription;
@property (weak,    nonatomic)  IBOutlet UISwitch         *switchStatus;

@property (weak,    nonatomic)  IBOutlet UILabel          *labelCategory;
@property (strong,  nonatomic)  PFObject                  *category;

@property (weak,    nonatomic)  IBOutlet UILabel          *labelColorTitle;
@property (weak,    nonatomic)  IBOutlet UIButton         *btnColorBack;
@property (strong,  nonatomic)  PFObject                  *color;

@property (weak,    nonatomic)  IBOutlet UILabel          *labelPackageDimensions;

@property (nonatomic) CGFloat shippingRate;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat length;
@property (nonatomic) CGFloat weight;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic) WYPopoverController       *chooseCategoryPO;
@property (strong,  nonatomic) WYPopoverController       *chooseColorPO;
@property (strong,  nonatomic) WYPopoverController       *editPackageDimensionsPO;

@end
