//
//  FMADeliveryMethodsView.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/23/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface FMADeliveryMethodsView : UIView<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// ----------------------------------------------------------------------------------------
@property (strong,  nonatomic)                  MBProgressHUD           *hud;
@property (strong,  nonatomic)                  UILabel                 *labelEmpty;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    UICollectionView        *collectionview;

@end
