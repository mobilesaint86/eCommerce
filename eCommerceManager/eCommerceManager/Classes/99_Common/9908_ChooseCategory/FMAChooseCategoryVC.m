//
//  FMAChooseCategoryVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/3/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAChooseCategoryVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMAChooseCategoryCVCell.h"

#define CELLID @"ChooseCategoryCVCell"

@interface FMAChooseCategoryVC ()

@end

@implementation FMAChooseCategoryVC
{
    NSArray     *dataSource;
    NSUInteger   selectedIndex;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAChooseCategoryVC) return;
    
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
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
    [self initDataSource];
}

- (void)didReceiveMemoryWarning
{
    [self printLogWith:@"didReceiveMemoryWarning"];
    [super didReceiveMemoryWarning];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    self.view.backgroundColor           = [UIColor clearColor];
    self.collectionview.backgroundColor = [UIColor clearColor];
    
    _hud = [FMAUtil initHUDWithView:self.view];
}

- (id)categoryByIndex:(int)i
{
    NSString   *title = [NSString stringWithFormat:@"Category%i", i];
    NSDictionary *res = @{kFMCategoryNameKey:title};
    
    return res;
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    [FMAUtil showHUD:self.hud withText:@""];
    
    PFQuery *query = [PFQuery queryWithClassName:kFMCategoryClassKey];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         [self.hud hide:YES];
         
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         else
         {
             dataSource = objects;
             
             selectedIndex = [FMAUtil indexOfPFObject:_category InObjects:dataSource];
             
             [_collectionview reloadData];
         }
     }];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate Functions
- (IBAction)onBtnSearch:(id)sender
{
    [self printLogWith:@"onBtnSearch"];
    
    [self.delegate chooseCategoryVCDidCancel];
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
    FMAChooseCategoryCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    PFObject *category            = [self cellDataAtIndexPath:indexPath];
    
    [cell configureCellWithData:category];
    
    if (indexPath.row == selectedIndex)
    {
        cell.btnChecked.hidden = NO;
    }
    else
    {
        cell.btnChecked.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"collectionView: didSelectItemAtIndexPath:"];
    [self printLogWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    // Uncheck the previous checked cell
    NSIndexPath *selectedIndexPath               = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
    FMAChooseCategoryCVCell *previousCheckedCell = (FMAChooseCategoryCVCell *)[collectionView cellForItemAtIndexPath:selectedIndexPath];
    previousCheckedCell.btnChecked.hidden        = YES;
    
    // Check the current clicked cell
    FMAChooseCategoryCVCell *currentCell         = (FMAChooseCategoryCVCell *)[collectionView cellForItemAtIndexPath:indexPath];
    currentCell.btnChecked.hidden                = NO;
    
    // Save the selected index
    selectedIndex = indexPath.row;
    
    [_delegate chooseCategoryVC:self didSelectCategory:[self cellDataAtIndexPath:indexPath]];
}


- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

@end
