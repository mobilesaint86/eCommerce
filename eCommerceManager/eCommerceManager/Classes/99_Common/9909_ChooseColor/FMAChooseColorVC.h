//
//  FMAChooseColorVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/3/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@class FMAChooseColorVC;

// ----------------------------------------------------------------------------------------
// FMAChooseColorVCDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMAChooseColorVCDelegate <NSObject>

- (void)chooseColorVCDidCancel;
- (void)chooseCategoryVC:(FMAChooseColorVC *)controller didSelectColor:(PFObject *)color;

@end

// ----------------------------------------------------------------------------------------
// FMAChooseColorVC Class
// ----------------------------------------------------------------------------------------
@interface FMAChooseColorVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic) id<FMAChooseColorVCDelegate> delegate;
@property (strong,  nonatomic) MBProgressHUD    *hud;
@property (strong,  nonatomic) PFObject         *color;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UICollectionView   *collectionview;

@end
