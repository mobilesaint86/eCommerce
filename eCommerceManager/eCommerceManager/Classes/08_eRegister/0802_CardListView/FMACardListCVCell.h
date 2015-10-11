//
//  FMACardListCVCell.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/27/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMACardListCVCell : UICollectionViewCell

// -------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UILabel    *labelCardType;
@property (weak, nonatomic) IBOutlet UILabel    *labelCardNumber;
@property (weak, nonatomic) IBOutlet UIButton   *btnRemove;

// -------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data isEditMode:(BOOL)bEdit;

@end
