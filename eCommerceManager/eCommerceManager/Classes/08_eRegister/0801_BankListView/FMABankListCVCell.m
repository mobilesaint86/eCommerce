//
//  FMABankListCVCell.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/27/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMABankListCVCell.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMAERegisterUtil.h"
#import "FMABank.h"

@implementation FMABankListCVCell

// --------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMABankListCVCell) return;
    
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
    
    FMABank *bank = (FMABank *)data;
    
    self.labelBankName.text   = bank.bankName;
    self.labelBankNumber.text = [bank displayAccountNumber];
    
    [self setEditMode:bEdit];
}

- (void)setEditMode:(BOOL)bEdit
{
    [self printLogWith:@"setEditMode"];
    
    self.btnRemove.hidden = !bEdit;
}

@end
