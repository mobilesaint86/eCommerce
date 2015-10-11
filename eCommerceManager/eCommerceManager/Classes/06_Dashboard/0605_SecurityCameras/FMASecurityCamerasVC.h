//
//  FMASecurityCamerasVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/25/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMABackgroundUtil.h"

@interface FMASecurityCamerasVC : UIViewController<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FMABackgroundUtilDelegate>
{
    BOOL bViewModeGrid;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)     IBOutlet    UICollectionView     *collectionview;
@property (weak,    nonatomic)     IBOutlet    UIBarButtonItem      *barBtnViewMode;

@end
