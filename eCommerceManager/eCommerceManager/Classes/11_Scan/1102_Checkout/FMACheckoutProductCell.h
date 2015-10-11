//
//  FMACheckoutProductCell.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/20/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class FMACheckoutProductCell;
// ----------------------------------------------------------------------------------------
// FMACheckoutProductCellDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMACheckoutProductCellDelegate <NSObject>

- (id)checkoutProductCellGetPrdouctData:(FMACheckoutProductCell *)cell;
- (void)checkoutProductCell:(FMACheckoutProductCell *)cell didUpdateQuantity:(int)quantity;

@end

// ----------------------------------------------------------------------------------------
// FMACheckoutProductCell Class
// ----------------------------------------------------------------------------------------
@interface FMACheckoutProductCell : UITableViewCell<UITextFieldDelegate>

// ----------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet id<FMACheckoutProductCellDelegate> delegate;

// ----------------------------------------------------------------------------------------
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity;
@property (weak, nonatomic) IBOutlet UILabel     *labelUnitPrice;
@property (weak, nonatomic) IBOutlet UILabel     *labelTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel     *labelProductTitle;
@property (weak, nonatomic) IBOutlet PFImageView *imageviewProduct;

// ----------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;

@end
