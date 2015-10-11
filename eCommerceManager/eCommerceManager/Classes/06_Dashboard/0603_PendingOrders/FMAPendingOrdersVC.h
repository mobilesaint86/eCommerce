//
//  FMAPendingOrdersVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/23/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "FMAPendingOrdersUtil.h"
#import "FMAPendingOrdersCVCell.h"
#import "FMABackgroundUtil.h"

@interface FMAPendingOrdersVC : UIViewController<UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FMAPendingOrdersCVCellDelegate, FMAPendingOrdersUtilDelegate, FMABackgroundUtilDelegate>
{
    BOOL bViewModeGrid;
}

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic)      MBProgressHUD *hud;
@property (strong,  nonatomic)      UILabel       *labelEmpty;

// --------------------------------------------------------------------------------------
@property (weak,    nonatomic)     IBOutlet    UICollectionView     *collectionview;
@property (weak,    nonatomic)     IBOutlet    UISearchBar          *searchBar;
@property (weak,    nonatomic)     IBOutlet    UIButton             *btnViewMode;

@end
