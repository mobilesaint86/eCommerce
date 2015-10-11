//
//  FMBDeliveryMethodsCVCell.h
//  eCommerceCustomer
//
//  Created by Albert Chen on 9/25/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FMBDeliveryMethodsCVCell : UICollectionViewCell

// -----------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UILabel     *labelTitle;

// -----------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;
- (void)changeColorWithSelected:(BOOL)bSelected;

@end
