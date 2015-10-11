//
//  FMABankListView.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/27/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMABank.h"

@class FMABankListView;
// ----------------------------------------------------------------------------------
// FMABankListViewDelegate Protocol
// ----------------------------------------------------------------------------------
@protocol FMABankListViewDelegate <NSObject>

- (void)bankListViewDidClickAddButton;

@end

// ----------------------------------------------------------------------------------
// FMABankListView Class
// ----------------------------------------------------------------------------------
@interface FMABankListView : UIView<UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate>

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic)      id<FMABankListViewDelegate>         delegate;
@property (nonatomic)               BOOL                                bEdit;

@property (strong,  nonatomic)                  UILabel                 *labelEmpty;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    UICollectionView        *collectionview;

// -----------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)addBank:(FMABank *)bank;

@end
