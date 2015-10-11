//
//  FMBShippingAddressListCVCell.h
//  eCommerceCustomer
//
//  Created by Albert Chen on 9/7/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMBShippingAddressListCVCell : UICollectionViewCell

// -------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UILabel    *labelStreet;
@property (weak, nonatomic) IBOutlet UILabel    *labelCityState;
@property (weak, nonatomic) IBOutlet UIButton   *btnRemove;

// -------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data isEditMode:(BOOL)bEdit;

@end
