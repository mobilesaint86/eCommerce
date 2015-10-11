//
//  FMBSocialShareVC.h
//  eCommerceCustomer
//
//  Created by Albert Chen on 9/6/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBData.h"

@class FMBSocialShareVC;
// ----------------------------------------------------------------------------------------
// FMBSocialShareVCDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMBSocialShareVCDelegate <NSObject>

- (void)socialShareVCDidCancel;
- (void)socialShareVCDidClickShareType:(FMBShareType)shareType;

@end

// ----------------------------------------------------------------------------------------
// FMBSocialShareVC Class
// ----------------------------------------------------------------------------------------
@interface FMBSocialShareVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

// ----------------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMBSocialShareVCDelegate> delegate;

// ----------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@end
