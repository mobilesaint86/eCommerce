//
//  FMACreateItemImageListView.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/2/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMACreateItemImageListView : UIView<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// ----------------------------------------------------------------------------------------
@property (strong,      nonatomic)           NSArray          *imageList;
@property (weak,        nonatomic)  IBOutlet UICollectionView *collectionview1;
@property (weak,        nonatomic)  IBOutlet UICollectionView *collectionview2;

@end
