//
//  FMAChooseCategoryCVCell.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/3/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMAChooseCategoryCVCell : UICollectionViewCell

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UIButton    *btnImage;
@property (weak, nonatomic) IBOutlet UILabel     *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton    *btnChecked;

// -----------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;

@end
