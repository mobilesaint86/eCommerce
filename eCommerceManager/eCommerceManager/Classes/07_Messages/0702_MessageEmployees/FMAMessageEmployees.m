//
//  FMAMessageEmployees.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/26/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAMessageEmployees.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMAMessageEmployeesCell.h"
#import "FMABackgroundSetting.h"

#define CELLID_MESSAGEEMPLOYEES                 @"MessageEmployeesCell"
#define CELLID_LOADMORE                         @"LoadMoreCell"
#define CELL_COLOR                              RGBHEX(0x90a2ae, 0.2f)

#define SEGID_EMPLOYEEMESSAGE                   @"SEGID_EmployeeMessage"

#define EMPTY_LABEL_TEXT                        @"No Employee(s) Found"

@interface FMAMessageEmployees ()

@end

@implementation FMAMessageEmployees
{
    NSMutableArray *dataSource;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAMessageEmployeesVC) return;
    
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
    
    _tableview.backgroundView  = self.labelEmpty;
    
    _hud = [FMAUtil initHUDWithView:self.view];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameMessages toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameMessages delegate:self];
    
    _tableview.backgroundColor  = [UIColor clearColor];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameMessages toImageView:_imageviewBackground];
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
    
    
    [FMAMessageEmployeesUtil requestGetEmployeesInMessageEmployeesPageWithFilterParams:[dataSource count] delegate:self];
}

- (void)requestGetEmployeesInMessageEmployeesPageWithFilterParamsDidRespondWithEmployees:(NSArray *)employees
{
    [self printLogWith:@"requestGetEmployeesInMessageEmployeesPageWithFilterParamsDidRespondWithEmployees"];
    
    [_hud hide:YES];
    
    if ([FMAUtil isObjectEmpty:dataSource])
    {
        dataSource = [NSMutableArray array];
    }
    [dataSource addObjectsFromArray:employees];
    [_tableview reloadData];
    
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
    
    if ([segue.identifier isEqualToString:SEGID_EMPLOYEEMESSAGE])
    {
        FMAEmployeeMessageVC *vc = [FMAUtil vcFromSegue:segue];
        vc.other = sender;
        
        [FMAUtil appDelegate].currentMessageVC = vc;
        
        vc.backgroundName = kFMBackgroundNameMessages;
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - TableView Functions
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

    return CELLID_MESSAGEEMPLOYEES;
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
        FMAMessageEmployeesCell *cell1 = (FMAMessageEmployeesCell *)cell;
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
        [self performSegueWithIdentifier:SEGID_EMPLOYEEMESSAGE sender:[self objectAtIndexPath:indexPath]];
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
