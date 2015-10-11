//
//  FMACustomerReviewsVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/25/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMACustomerReviewsVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMACustomerReviewsCell.h"
#import "FMABackgroundSetting.h"

#define CELLID_CUSTOMERREVIEWS               @"CustomerReviewsCell"
#define CELLID_LOADMORE                      @"LoadMoreCell"
#define CELL_COLOR                           RGBHEX(0x90a2ae, 0.2f)

#define SEGID_CUSTOMERMESSAGE                @"SEGID_CustomerMessage"

#define EMPTY_LABEL_TEXT                     @"No Review(s) Found"

@interface FMACustomerReviewsVC ()

@end

@implementation FMACustomerReviewsVC
{
    NSMutableArray      *dataSource;
    NSString            *searchString;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMACustomerReviewsVC) return;
    
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
    [self initSearchBar];
    
    _tableview.backgroundView  = self.labelEmpty;
    
    _hud = [FMAUtil initHUDWithView:self.view];
}
- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameDashboard toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameDashboard delegate:self];
    
    _tableview.backgroundColor  = [UIColor clearColor];
}

- (void)initSearchBar
{
    [self printLogWith:@"initSearchBar"];
    
    _searchBar.enablesReturnKeyAutomatically = NO;
    
    [FMAThemeManager makeTransparentSearchBar:_searchBar];
    
    [FMAUtil setupInputAccessoryViewWithButtonTitle:@"Cancel"
                                           selector:@selector(onBtnCancelInInputAccessoryView:)
                                             target:self
                                         forControl:_searchBar];
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
    
    
    [FMACustomerReviewsUtil requestGetOrdersInCustomerReviewsPage:[dataSource count]
                                                     searchString:_searchBar.text delegate:self];
}

- (void)sendRequestOnSettingsChanged
{
    [self printLogWith:@"sendRequestOnSettingsChanged"];
    
    [FMAUtil showHUD:_hud withText:@""];
    
    [dataSource removeAllObjects];
    [_tableview reloadData];
    
    [FMACustomerReviewsUtil requestGetOrdersInCustomerReviewsPage:[dataSource count] searchString:searchString delegate:self];
}

- (void)requestGetOrdersInCustomerReviewsPageDidRespondWithOrders:(NSArray *)orders
{
    [self printLogWith:@"requestGetOrdersInCustomerReviewsPageDidRespondWithOrders"];
    
    [_hud hide:YES];
    
    if ([FMAUtil isObjectEmpty:dataSource])
    {
        dataSource = [NSMutableArray array];
    }
    [dataSource addObjectsFromArray:orders];
    [_tableview reloadData];
    
    [self layoutEmptyLabel];
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
#pragma mark - Empty Label Functions
- (UILabel *)labelEmpty
{
    [self printLogWith:@"emptyLabel"];
    
    if (!_labelEmpty)
    {
        UILabel *label = [[UILabel alloc] init];
        
        CGRect rect = _tableview.frame;
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
    
    if ([segue.identifier isEqualToString:SEGID_CUSTOMERMESSAGE])
    {
        FMACustomerMessageVC *vc = [FMAUtil vcFromSegue:segue];
        vc.other                 = sender[kFMOrderCustomerKey];
        
        [FMAUtil appDelegate].currentMessageVC = vc;
        
        vc.backgroundName = kFMBackgroundNameDashboard;
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - UISearchBarDelegate
- (void)onBtnCancelInInputAccessoryView:(id)sender
{
    [self printLogWith:@"onBtnCancelInInputAccessoryView"];
    
    [_searchBar resignFirstResponder];
    
    _searchBar.text = searchString;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self printLogWith:@"searchBarSearchButtonClicked"];
    
    [_searchBar resignFirstResponder];
    
    searchString = _searchBar.text;
    [self sendRequestOnSettingsChanged];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - TableView Delegate Functions
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
    
    return CELLID_CUSTOMERREVIEWS;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dataSource count] > 0)
    {
        return [dataSource count] + 1;
    }
    
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForIndexPath:indexPath]];
    
    if (indexPath.row < [dataSource count])
    {
        FMACustomerReviewsCell *cell1 = (FMACustomerReviewsCell *)cell;
        [cell1 configureCellWithData:[self objectAtIndexPath:indexPath]];
        
        [FMAThemeManager decorateEvenOddStyleForCell:cell1 indexPath:indexPath cellColor:CELL_COLOR];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"tableView: didSelectRowAtIndexPath"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == [dataSource count])
    {
        [self sendRequest];
    }
    else
    {
        [self performSegueWithIdentifier:SEGID_CUSTOMERMESSAGE sender:[self objectAtIndexPath:indexPath]];
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.alpha = 0.5f;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

@end
