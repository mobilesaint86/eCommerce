//
//  FMACameraVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/1/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBJVision.h"
#import "PBJVisionUtilities.h"
#import "PBJFocusView.h"
#import <GLKit/GLKit.h>

@class FMACameraVC;
// ----------------------------------------------------------------------------------------
// FMACameraVCDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMACameraVCDelegate <NSObject>

- (void)cameraVC:(FMACameraVC *)cameraVC didTakePhoto:(UIImage *)image;
- (UIView *)cameraContainerView;

@end

// ----------------------------------------------------------------------------------------
// FMACameraVC Class
// ----------------------------------------------------------------------------------------
@interface FMACameraVC : UIViewController<PBJVisionDelegate>
{
    PBJFocusView *_focusView;
    UIView *_previewView;
    AVCaptureVideoPreviewLayer *_previewLayer;
    GLKViewController *_effectsViewController;
}

// ----------------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMACameraVCDelegate> delegate;

// ----------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)takePhoto;

@end
