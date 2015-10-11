//
//  FMAPendingOrdersCVCell.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/23/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>

@class FMAPendingOrdersCVCell;
// -----------------------------------------------------------------------------------
// FMAPendingOrdersCVCellDelegate Protocol
// -----------------------------------------------------------------------------------
@protocol FMAPendingOrdersCVCellDelegate <NSObject>

- (BOOL)pendingOrdersCVCellCheckViewModeGrid;

@end

// -----------------------------------------------------------------------------------
// FMAPendingOrdersCVCell Class
// -----------------------------------------------------------------------------------
@interface FMAPendingOrdersCVCell : UICollectionViewCell

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) id<FMAPendingOrdersCVCellDelegate> delegate;

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet PFImageView        *imageview;
@property (weak, nonatomic) IBOutlet UILabel            *labelProductTitles;
@property (weak, nonatomic) IBOutlet UILabel            *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel            *labelOrderedPeriod;

// -----------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;

@end
