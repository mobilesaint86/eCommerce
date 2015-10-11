//
//  FMAEmployeesCVCell.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/25/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FMAEmployeesCVCell : UICollectionViewCell

// -----------------------------------------------------------------------------------
@property (weak,   nonatomic) IBOutlet PFImageView      *imageviewEmployee;
@property (weak,   nonatomic) IBOutlet UILabel          *labelName;

// -----------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data;

@end
