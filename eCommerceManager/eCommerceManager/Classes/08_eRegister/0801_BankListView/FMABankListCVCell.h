//
//  FMABankListCVCell.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/27/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMABankListCVCell : UICollectionViewCell

// --------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UILabel    *labelBankName;
@property (weak, nonatomic) IBOutlet UILabel    *labelBankNumber;
@property (weak, nonatomic) IBOutlet UIButton   *btnRemove;

// --------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data isEditMode:(BOOL)bEdit;

@end
