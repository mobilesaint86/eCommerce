//
//  FMAEmployeesVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/25/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAEmployeesVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMAEmployeesCVCell.h"
#import "FMABackgroundSetting.h"

#define CELLID_EMPLOYEES                        @"EmployeesCVCell"
#define CELLID_LOADMORE                         @"LoadMoreCell"

#define SEGID_MESSAGEBOARD                      @"SEGID_MessageBoard"
#define SEGID_EMPLOYEEMESSAGE                   @"SEGID_EmployeeMessage"

#define EMPTY_LABEL_TEXT                        @"No Employee(s) Found"

@interface FMAEmployeesVC ()

@end

@implementation FMAEmployeesVC
{
    NSMutableArray *dataSource;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAEmployeesVC) return;
    
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
    [self initDataSource];
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
    
    _hud = [FMAUtil initHUDWithView:self.view];
    
    _collectionview.backgroundView  = self.labelEmpty;
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameDashboard toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameDashboard delegate:self];
    
    _collectionview.backgroundColor = [UIColor clearColor];
    _viewBottom.backgroundColor     = [UIColor clearColor];
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

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Data Source Functions
- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    [self sendRequest];
}

- (void)sendRequest
{
    [self printLogWith:@"sendRequest"];
    
    [FMAUtil showHUD:_hud withText:@""];
    
    
    [FMAEmployeesUtil requestGetEmployeesInEmployeesPageWithFilterParams:[dataSource count] delegate:self];
}

- (void)requestGetEmployeesInEmployeesPageWithFilterParamsDidRespondWithEmployees:(NSArray *)employees
{
    [self printLogWith:@"requestGetEmployeesInEmployeesPageWithFilterParamsDidRespondWithEmployees"];
    
    [_hud hide:YES];
    
    if ([FMAUtil isObjectEmpty:dataSource])
    {
        dataSource = [NSMutableArray array];
    }
    [dataSource addObjectsFromArray:employees];
    [_collectionview reloadData];
    
    [self layoutEmptyLabel];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Empty Label Functions
- (UILabel *)labelEmpty
{
    [self printLogWith:@"emptyLabel"];
    
    if (!_labelEmpty)
    {
        UILabel *label = [[UILabel alloc] init];
        
        CGRect rect = _collectionview.frame;
        rect.origin = CGPointMake(0.f, 0.f);
        label.frame = rect;
        label.text  = EMPTY_LABEL_TEXT;
        
        label.textAlignment = NSTextAlignmentCenter;
        label.font          = COMMON_FONT_FOR_EMPTY_LISTVIEW_LABEL;
        label.textColor     = COMMON_COLOR_FOR_EMPTY_LISTVIEW_LABEL;
        
        _labelEmpty = label;
    }
    
    return _labelEmpty;
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

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self printLogWith:@"prepareForSegue"];
    
    if ([segue.identifier isEqualToString:SEGID_MESSAGEBOARD])
    {
        FMAMessageBoardVC *vc = [FMAUtil vcFromSegue:segue];
        [FMAUtil appDelegate].currentMessageVC = vc;
        vc.backgroundName = kFMBackgroundNameDashboard;
    }
    if ([segue.identifier isEqualToString:SEGID_EMPLOYEEMESSAGE])
    {
        FMAEmployeeMessageVC *vc = [FMAUtil vcFromSegue:segue];
                        vc.other = sender;
        
        [FMAUtil appDelegate].currentMessageVC = vc;
        vc.backgroundName = kFMBackgroundNameDashboard;
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Collection View Delegate Functions
- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [dataSource objectAtIndex:indexPath.row];
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [dataSource count])
    {
        return CELLID_LOADMORE;
    }
    
    return CELLID_EMPLOYEES;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([dataSource count] > 0)
    {
        return [dataSource count] + 1;
    }
    
    return [dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMAEmployeesCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIdentifierForIndexPath:indexPath] forIndexPath:indexPath];
    
    if (indexPath.row < [dataSource count])
    {
        FMAEmployeesCVCell *cell1 = (FMAEmployeesCVCell *)cell;
        
        [cell1 configureCellWithData:[self objectAtIndexPath:indexPath]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"collectionView: didSelectItemAtIndexPath:"];
    [self printLogWith:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    if (indexPath.row == [dataSource count])
    {
        [self sendRequest];
    }
    else
    {
        [self performSegueWithIdentifier:SEGID_EMPLOYEEMESSAGE sender:[self objectAtIndexPath:indexPath]];
    }
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMAEmployeesCVCell *cell = (FMAEmployeesCVCell *)[colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

@end
