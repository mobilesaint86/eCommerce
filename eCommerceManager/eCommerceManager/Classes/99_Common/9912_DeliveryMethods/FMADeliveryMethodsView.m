//
//  FMADeliveryMethodsView.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/23/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMADeliveryMethodsView.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAThemeManager.h"
#import "FMAUtil.h"
#import "FMADeliveryMethodsCVCell.h"

#define CELLID                              @"DeliveryMethodsCell"

#define EMPTY_LABEL_TEXT                    @"No Delivery Method(s)"

@implementation FMADeliveryMethodsView
{
    NSMutableArray *dataSource;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMADeliveryMethodsView) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self printLogWith:@"initWithCoder"];
    
    if ((self = [super initWithCoder:aDecoder]))
    {
    }
    return self;
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - LifeCycle Functions
- (void)awakeFromNib
{
    [self printLogWith:@"awakeFromNib"];
    [super awakeFromNib];
    
    [self initUI];
    [self initDataSource];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    self.backgroundColor            = [UIColor clearColor];
    
    _collectionview.backgroundColor = [UIColor clearColor];
    _collectionview.backgroundView  = self.labelEmpty;
    
    _hud = [FMAUtil initHUDWithView:self];
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    PFQuery *query = [PFQuery queryWithClassName:kFMDeliveryMethodClassKey];
    
    [query orderByAscending:kFMDeliveryMethodSortOrderKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
        }
        else
        {
            if ([dataSource count]==0)
            {
                dataSource = [NSMutableArray array];
            }
            
            [dataSource addObjectsFromArray:objects];
            
            [_collectionview reloadData];
            
            [self layoutEmptyLabel];
        }
    }];
}

- (void)layoutEmptyLabel
{
    [self printLogWith:@"layoutEmptyLabel"];
    
    if ([dataSource count] > 0)
    {
        self.labelEmpty.text = @"";
    }
    else
    {
        self.labelEmpty.text = EMPTY_LABEL_TEXT;
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate Functions
- (id)cellDataAtIndexPath:(NSIndexPath *)indexPath
{
    return [dataSource objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMADeliveryMethodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    
    [cell configureCellWithData:[self cellDataAtIndexPath:indexPath]];
    
    [cell changeColorWithSelected:YES];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"collectionView: didSelectItemAtIndexPath:"];
    [self printLogWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = (UICollectionViewCell *)[colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

@end
