//
//  FMBMessageListCell.h
//  eCommerceCustomer
//
//  Created by Albert Chen on 9/8/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FMBMessageListCell : UITableViewCell

// ----------------------------------------------------------------------------------------
@property (weak,   nonatomic) IBOutlet PFImageView      *imageviewManager;
@property (weak,   nonatomic) IBOutlet PFImageView      *imageviewItem;

// ----------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;

@end
