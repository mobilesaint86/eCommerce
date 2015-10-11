//
//  FMACardListCVCell.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/27/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMACardListCVCell.h"
#import "FMAData.h"
#import "FMAUtil.h"
#import "PKCard.h"

@implementation FMACardListCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMACardListCVCell) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (void)configureCellWithData:(id)data isEditMode:(BOOL)bEdit
{
    [self printLogWith:@"configureCellWithData"];
    
    PKCard *card = (PKCard *)data;
    
    self.labelCardNumber.text = [card displayCardNumber];
    self.labelCardType.text   = [card displayCardType];
    
    [self setEditMode:bEdit];
}

- (void)setEditMode:(BOOL)bEdit
{
    [self printLogWith:@"setEditMode"];
    
    self.btnRemove.hidden = !bEdit;
}

@end
