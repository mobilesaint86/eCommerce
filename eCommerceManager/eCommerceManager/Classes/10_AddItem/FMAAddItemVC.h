//
//  FMAAddItemVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/1/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AviarySDK/AviarySDK.h>
#import "FMACameraVC.h"
#import "FMACreateItemVC.h"

// ----------------------------------------------------------------------------------------
// FMAAddItemVC Class
// ----------------------------------------------------------------------------------------
@interface FMAAddItemVC : UIViewController<FMACameraVCDelegate, UICollectionViewDataSource, UICollectionViewDelegate, AFPhotoEditorControllerDelegate, FMACreateItemVCDelegate>

// ----------------------------------------------------------------------------------------
@property (strong,  nonatomic) FMACameraVC *cameraVC;

// ----------------------------------------------------------------------------------------
@property (strong,  nonatomic) PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------------
@property (strong,  nonatomic) IBOutlet UIView           *viewCameraViewContainer;
@property (weak,    nonatomic) IBOutlet UIView           *viewBottomBar;
@property (weak,    nonatomic) IBOutlet UICollectionView *collectionview;
@property (weak,    nonatomic) IBOutlet UIButton         *btnTakePhoto;
@property (weak,    nonatomic) IBOutlet UIView           *viewBtnFlash;
@property (weak,    nonatomic) IBOutlet UIView           *viewBtnCameraMode;
@property (weak,    nonatomic) IBOutlet UILabel          *labelFlashMode;

@end
