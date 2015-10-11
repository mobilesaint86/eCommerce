//
//  FMASecurityCamerasVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/25/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMASecurityCamerasVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMASecurityCamerasCVCell.h"
#import "FMABackgroundSetting.h"

#define VIEW_MODE_SINGLE_IMAGE          @"00_singleview"
#define VIEW_MODE_GRID_IMAGE            @"00_gridview"

#define CELLID_SINGLECELL4              @"SecurityCamerasSingleCell4"
#define CELLID_SINGLECELL35             @"SecurityCamerasSingleCell35"
#define CELLID_GRIDCELL4                @"SecurityCamerasGridCell4"
#define CELLID_GRIDCELL35               @"SecurityCamerasGridCell35"

@interface FMASecurityCamerasVC ()

@end

@implementation FMASecurityCamerasVC

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMASecurityCamerasVC) return;
    
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

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [self printLogWith:@"didReceiveMemoryWarning"];
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initViewBackground];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameDashboard toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameDashboard delegate:self];
    
    _collectionview.backgroundColor = [UIColor clearColor];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameDashboard toImageView:_imageviewBackground];
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnViewMode:(id)sender
{
    [self printLogWith:@"onBtnViewMode"];
    
    bViewModeGrid = !bViewModeGrid;
    [self changeViewModeIntoGrid:bViewModeGrid];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Core Functions
- (void)changeViewModeIntoGrid:(BOOL)bGridViewMode
{
    [self printLogWith:@"changeViewModeIntoSingle"];
    
    NSString *imageName = bGridViewMode ? VIEW_MODE_SINGLE_IMAGE : VIEW_MODE_GRID_IMAGE;
    [self.barBtnViewMode setImage:[UIImage imageNamed:imageName]];
    
    [self.collectionview reloadData];
}

- (CGSize)cellSize
{
    CGSize res;
    if (bViewModeGrid)
    {
        if ([FMAUtil isRetina4])
        {
            res = CGSizeMake(150.f, 248.f);
        }
        else
        {
            res = CGSizeMake(150.f, 205.f);
        }
    }
    else
    {
        if ([FMAUtil isRetina4])
        {
            res = CGSizeMake(300.f, 500.f);
        }
        else
        {
            res = CGSizeMake(300.f, 410.f);
        }
    }
    return res;
}

- (NSString *)cellIdentifier
{
    NSString *res;
    if (bViewModeGrid)
    {
        if ([FMAUtil isRetina4])
        {
            res = CELLID_GRIDCELL4;
        }
        else
        {
            res = CELLID_GRIDCELL35;
        }
    }
    else
    {
        if ([FMAUtil isRetina4])
        {
            res = CELLID_SINGLECELL4;
        }
        else
        {
            res = CELLID_SINGLECELL35;
        }
    }
    return res;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate Functions
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 13;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellSize];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMASecurityCamerasCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIdentifier]
                                                                      forIndexPath:indexPath];
    [cell configureCellWithData:nil];
    
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
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

@end
