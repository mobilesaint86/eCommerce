//
//  FMABrowseVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/18/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "WYPopoverController.h"
#import "FMASocialShareVC.h"
#import "FMABrowseCVCell.h"
#import "FMAPriceRangeVC.h"
#import "FMAFilterCategoryVC.h"
#import "FMASignupVC.h"
#import "FMABrowseUtil.h"
#import "FMAShareUtil.h"
#import "FMABackgroundUtil.h"

@interface FMABrowseVC : UIViewController<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, WYPopoverControllerDelegate, FMASocialShareVCDelegate, FMABrowseCVCellDelegate, FMAPriceRangeVCDelegate, FMAFilterCategoryVCDelegate, FMABrowseUtilDelegate, FMAShareUtilDelegate, MFMailComposeViewControllerDelegate, FMABackgroundUtilDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic) PFImageView *imageviewBackground;
@property (strong,  nonatomic) NSTimer     *timerBackground;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic) MBProgressHUD *hud;
@property (strong,  nonatomic) UILabel       *labelEmpty;

@property (strong,  nonatomic)          UISearchBar         *searchBar;
@property (weak,    nonatomic) IBOutlet UIBarButtonItem     *barBtnViewMode;

// ----------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UICollectionView    *collectionview;
@property (weak,    nonatomic) IBOutlet UIToolbar           *toolbar;

// ----------------------------------------------------------------------------------
@property (strong,  nonatomic) WYPopoverController       *socialSharePO;
@property (strong,  nonatomic) WYPopoverController       *priceRangePO;
@property (strong,  nonatomic) WYPopoverController       *filterCategoryPO;

@end
