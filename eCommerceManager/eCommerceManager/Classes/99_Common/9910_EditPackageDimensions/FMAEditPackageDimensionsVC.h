//
//  FMAEditPackageDimensionsVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/3/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMAEditPackageDimensionsVC;
// ----------------------------------------------------------------------------------------
// FMAEditPackageDimensionsVCDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMAEditPackageDimensionsVCDelegate <NSObject>

- (void)editPackageDimensionsVCDidCancel;
- (void)editPackageDimensionsVC:(FMAEditPackageDimensionsVC *)controller
            didEditShippingRate:(CGFloat)shippingRate width:(CGFloat)width
                         height:(CGFloat)height length:(CGFloat)length weight:(CGFloat)weight;

@end

// ----------------------------------------------------------------------------------------
// FMAEditPackageDimensionsVC Class
// ----------------------------------------------------------------------------------------
@interface FMAEditPackageDimensionsVC : UIViewController<UITextFieldDelegate>
{
    UITextField *activeField;
}

// ----------------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMAEditPackageDimensionsVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
// ----------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UITextField *txtShippingPrice;
@property (weak, nonatomic) IBOutlet UITextField *txtLength;
@property (weak, nonatomic) IBOutlet UITextField *txtWidth;
@property (weak, nonatomic) IBOutlet UITextField *txtHeight;
@property (weak, nonatomic) IBOutlet UITextField *txtWeight;

// ----------------------------------------------------------------------------------------
@property (nonatomic) CGFloat shippingRate;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat length;
@property (nonatomic) CGFloat weight;

@end
