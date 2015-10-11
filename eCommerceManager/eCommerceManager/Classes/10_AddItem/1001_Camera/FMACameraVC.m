//
//  FMACameraVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/1/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMACameraVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"

@interface FMACameraVC ()

@end

@implementation FMACameraVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMACameraVC) return;
    
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

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // iOS 6 support
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [self _resetCapture];
    [[PBJVision sharedInstance] startPreview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[PBJVision sharedInstance] stopPreview];
    
    // iOS 6 support
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)didReceiveMemoryWarning
{
    [self printLogWith:@"didReceiveMemoryWarning"];
    [super didReceiveMemoryWarning];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (CGFloat)heightForPreviewFrame
{
    [self printLogWith:@"heightForPreviewFrame"];
    
    if ([FMAUtil isRetina4])
    {
        return 406.f;
    }
    
    return 318.f;
}

- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initTheme];
    
    // preview and AV layer
    _previewView = [[UIView alloc] initWithFrame:CGRectZero];
    _previewView.backgroundColor = [UIColor blackColor];
    CGRect previewFrame = CGRectMake(0, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
//    CGRect previewFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), [self heightForPreviewFrame]);
    _previewView.frame = previewFrame;
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    _previewLayer.frame = _previewView.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_previewView.layer addSublayer:_previewLayer];
    
    // onion skin
    _effectsViewController = [[GLKViewController alloc] init];
    _effectsViewController.preferredFramesPerSecond = 60;
    
    GLKView *view = (GLKView *)_effectsViewController.view;
    CGRect viewFrame = _previewView.bounds;
    view.frame   = viewFrame;
    view.context = [[PBJVision sharedInstance] context];
    view.contentScaleFactor = [[UIScreen mainScreen] scale];
    view.alpha  = 0.5f;
    view.hidden = YES;
    [[PBJVision sharedInstance] setPresentationFrame:_previewView.frame];
    [_previewView addSubview:_effectsViewController.view];
    
    // focus view
    _focusView = [[PBJFocusView alloc] initWithFrame:CGRectZero];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
}

- (void)_resetCapture
{
    PBJVision *vision = [PBJVision sharedInstance];
    vision.delegate = self;
    
    if ([vision isCameraDeviceAvailable:PBJCameraDeviceBack])
    {
        vision.cameraDevice = PBJCameraDeviceBack;
        //        _flipButton.hidden = NO;
    }
    else
    {
        vision.cameraDevice = PBJCameraDeviceFront;
        //        _flipButton.hidden = YES;
    }
    
    vision.cameraMode                       = PBJCameraModePhoto;
    vision.cameraOrientation                = PBJCameraOrientationPortrait;
    vision.focusMode                        = PBJFocusModeContinuousAutoFocus;
    vision.outputFormat                     = PBJOutputFormatSquare;
    vision.videoRenderingEnabled            = YES;
    vision.additionalCompressionProperties  = @{AVVideoProfileLevelKey : AVVideoProfileLevelH264Baseline30};
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)takePhoto
{
    [self printLogWith:@"takePhoto"];
    
    [[PBJVision sharedInstance] capturePhoto];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - PBJVisionDelegate
// session
- (void)visionSessionWillStart:(PBJVision *)vision
{
}

- (void)visionSessionDidStart:(PBJVision *)vision
{
    if (![_previewView superview]) {
        [self.view addSubview:_previewView];
    }
}

- (void)visionSessionDidStop:(PBJVision *)vision
{
    [_previewView removeFromSuperview];
}

// preview
- (void)visionSessionDidStartPreview:(PBJVision *)vision
{
    [self printLogWith:@"visionSessionDidStartPreview"];
}

- (void)visionSessionDidStopPreview:(PBJVision *)vision
{
    [self printLogWith:@"visionSessionDidStopPreview"];
}

// device
- (void)visionCameraDeviceWillChange:(PBJVision *)vision
{
    [self printLogWith:@"visionCameraDeviceWillChange"];
}

- (void)visionCameraDeviceDidChange:(PBJVision *)vision
{
    [self printLogWith:@"visionCameraDeviceDidChange"];
}

// mode
- (void)visionCameraModeWillChange:(PBJVision *)vision
{
    [self printLogWith:@"visionCameraModeWillChange"];
}

- (void)visionCameraModeDidChange:(PBJVision *)vision
{
    [self printLogWith:@"visionCameraModeDidChange"];
}

// format
- (void)visionOutputFormatWillChange:(PBJVision *)vision
{
    [self printLogWith:@"visionOutputFormatWillChange"];
}

- (void)visionOutputFormatDidChange:(PBJVision *)vision
{
    [self printLogWith:@"visionOutputFormatDidChange"];
}

- (void)vision:(PBJVision *)vision didChangeCleanAperture:(CGRect)cleanAperture
{
}

// focus / exposure
- (void)visionWillStartFocus:(PBJVision *)vision
{
}

- (void)visionDidStopFocus:(PBJVision *)vision
{
    if (_focusView && [_focusView superview]) {
        [_focusView stopAnimation];
    }
}

- (void)visionWillChangeExposure:(PBJVision *)vision
{
}

- (void)visionDidChangeExposure:(PBJVision *)vision
{
    if (_focusView && [_focusView superview]) {
        [_focusView stopAnimation];
    }
}

// flash
- (void)visionDidChangeFlashMode:(PBJVision *)vision
{
    [self printLogWith:@"visionDidChangeFlashMode"];
}

// photo
- (void)visionWillCapturePhoto:(PBJVision *)vision
{
}

- (void)visionDidCapturePhoto:(PBJVision *)vision
{
}

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error
{
    [self printLogWith:@"vision capturedPhoto"];
    
    // photo captured, PBJVisionPhotoJPEGKey
    if (error)
    {
        [self printLogWith:[error localizedDescription]];
        return;
    }
    
    UIImage *takenImage = [UIImage imageWithData:[photoDict objectForKey:PBJVisionPhotoJPEGKey]];
    
    [self.delegate cameraVC:self didTakePhoto:takenImage];
    
    [self _resetCapture];
    
    //    [vision stopPreview];
    [vision unfreezePreview];
}

// video capture
- (void)visionDidStartVideoCapture:(PBJVision *)vision
{
}

- (void)visionDidPauseVideoCapture:(PBJVision *)vision
{
}

- (void)visionDidResumeVideoCapture:(PBJVision *)vision
{
}

- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
{
}

// progress
- (void)visionDidCaptureAudioSample:(PBJVision *)vision
{
    //    NSLog(@"captured audio (%f) seconds", vision.capturedAudioSeconds);
}

- (void)visionDidCaptureVideoSample:(PBJVision *)vision
{
    //    NSLog(@"captured video (%f) seconds", vision.capturedVideoSeconds);
}

@end
