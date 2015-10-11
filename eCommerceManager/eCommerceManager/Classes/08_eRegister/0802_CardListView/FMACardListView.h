//
//  FMACardListView.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/27/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKCard.h"

@class FMACardListView;
// -------------------------------------------------------------------------------------
// FMACardListViewDelegate Protocol
// -------------------------------------------------------------------------------------
@protocol FMACardListViewDelegate <NSObject>

- (void)cardListViewDidClickAddButton;

@end

// -------------------------------------------------------------------------------------
// FMACardListView Class
// -------------------------------------------------------------------------------------
@interface FMACardListView : UIView<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

// -------------------------------------------------------------------------------------
@property (weak,    nonatomic)      id<FMACardListViewDelegate> delegate;
@property (nonatomic)               BOOL                        bEdit;
@property (strong,  nonatomic)      UILabel                     *labelEmpty;

// -------------------------------------------------------------------------------------
@property (weak,    nonatomic)      IBOutlet    UICollectionView        *collectionview;

// -------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)addCard:(PKCard *)card;

@end
