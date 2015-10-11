//
//  FMACreateItemImageListView.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/2/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMACreateItemImageListView.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"

#define CELLID_BIG                      @"CreateItemImageListViewBigCell"
#define CELLID_SMALL                    @"CreateItemImageListViewSmallCell"

@implementation FMACreateItemImageListView
{
    NSMutableArray *dataSource;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMACreateItemImageListView) return;
    
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
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initTheme];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    _collectionview1.backgroundColor = [UIColor clearColor];
    _collectionview2.backgroundColor = [UIColor clearColor];
}

- (void)setImageList:(NSArray *)imageList
{
    [self printLogWith:@"setImageList"];
    
    _imageList = imageList;
    
    dataSource = [[NSMutableArray alloc] init];
    
    for (int i=0; i<MAX_COUNT_ITEM_IMAGES; i++)
    {
        if (i < [_imageList count])
        {
            [dataSource addObject:[_imageList objectAtIndex:i]];
        }
        else
        {
            [dataSource addObject:[NSNull null]];
        }
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate Functions
- (CGSize)cellSizeForCollectionView:(UICollectionView *)cv
{
    if (cv == _collectionview1)
    {
        return CGSizeMake(300, 350);
    }
    
    return CGSizeMake(55, 55);
}

- (NSString *)cellIDForCollectionView:(UICollectionView *)cv
{
    if (cv == _collectionview1)
    {
        return CELLID_BIG;
    }
    
    return CELLID_SMALL;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [dataSource objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collectionview1)
    {
        return [_imageList count];
    }
    return [dataSource count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellSizeForCollectionView:collectionView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIDForCollectionView:collectionView]
                                                                           forIndexPath:indexPath];
    
    UIImageView *imageview = (UIImageView *)[cell viewWithTag:105];
    
    [FMAThemeManager setBorderToView:imageview width:1.f Color:[UIColor lightGrayColor]];
    
    if ([FMAUtil isObjectNotEmpty:[self objectAtIndexPath:indexPath]])
    {
        imageview.image = [self objectAtIndexPath:indexPath];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"collectionView: didSelectItemAtIndexPath:"];
    
    if (collectionView == _collectionview2 && indexPath.row < _imageList.count)
    {
        [_collectionview1 scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

@end
