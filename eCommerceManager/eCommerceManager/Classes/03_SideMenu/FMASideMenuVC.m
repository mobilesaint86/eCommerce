//
//  FMASideMenuVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/19/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMASideMenuVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "REFrostedViewController.h"

#define CELLID_TOP          @"SideMenuTopCell"
#define CELLID_DEFAULT      @"SideMenuDefaultCell"
#define CELLID_EMPTY        @"SideMenuEmptyCell"
#define CELLID_BOTTOM       @"SideMenuBottomCell"

#define CELLHEIGHT_TOP      80.f
#define CELLHEIGHT_TOP35    50.f
#define CELLHEIGHT_BOTTOM   60.f
#define CELLHEIGHT_DEFAULT  55.f

#define TAG_IMAGE_BUTTON    105
#define TAG_TITLE_LABEL     106

#define TAG_BUTTON_SCAN     115
#define TAG_BUTTON_ADD_ITEM 116

@interface FMASideMenuVC ()

@end

@implementation FMASideMenuVC

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMASideMenuVC) return;
    
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
    
    [self initViewBackground];
    [self initTableViewStyle];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    [self updateViewBackground];
}

- (void)updateViewBackground
{
    UINavigationController *nc = (UINavigationController *)[[[FMAUtil appDelegate] menuContainerVC] contentViewController];
    
    UIImage *image = [FMAThemeManager snapshotImageFromVC:[nc viewControllers][0]];
    self.imageviewBackground.image = [FMAThemeManager blurImageForSideMenuByImage:image];
}

- (void)initTableViewStyle
{
    [self printLogWith:@"initTableViewStyle"];
    
    _tableview.backgroundColor = [UIColor clearColor];
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    self.dataSource = @[@{kFMASideMenuItemTitleKey:kFMASideMenuItemTitleEmpty,          kFMASideMenuItemImageKey:@""},
                        @{kFMASideMenuItemTitleKey:kFMASideMenuItemTitleStore,          kFMASideMenuItemImageKey:@""},
                        @{kFMASideMenuItemTitleKey:kFMASideMenuItemTitleAbout,          kFMASideMenuItemImageKey:@""},
                        @{kFMASideMenuItemTitleKey:kFMASideMenuItemTitleDashboard,      kFMASideMenuItemImageKey:@"03_dashboard"},
                        @{kFMASideMenuItemTitleKey:kFMASideMenuItemTitleMessages,       kFMASideMenuItemImageKey:@"03_messages"},
                        @{kFMASideMenuItemTitleKey:kFMASideMenuItemTitleWallet,         kFMASideMenuItemImageKey:@"03_eregister"},
                        @{kFMASideMenuItemTitleKey:kFMASideMenuItemTitleSettings,       kFMASideMenuItemImageKey:@"03_settings"},
                        @{kFMASideMenuItemTitleKey:kFMASideMenuItemTitleAddInventory,   kFMASideMenuItemImageKey:@""},
                        @{kFMASideMenuItemTitleKey:kFMASideMenuItemTitleBarcode,        kFMASideMenuItemImageKey:@""},
                        @{kFMASideMenuItemTitleKey:kFMASideMenuItemTitleEmpty,          kFMASideMenuItemImageKey:@""},
                        @{kFMASideMenuItemTitleKey:kFMASideMenuItemTitleLogout,         kFMASideMenuItemImageKey:@""},
                        ];
}

- (CGSize)menuSize
{
    CGSize res;
    
    res.width   = 240.f;
    res.height  = [FMAUtil screenRect].size.height;
    
    return res;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Table View Delegate Functions
- (NSDictionary *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataSource[indexPath.row];
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath tableview:(UITableView *)tableView
{
    UITableViewCell *res;
    NSString        *cellID;
    
    if (indexPath.row == self.dataSource.count-2 || indexPath.row == 0)
    {
        cellID = CELLID_EMPTY;
    }
    else
    {
        cellID = CELLID_DEFAULT;
    }
    
    res = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    return res;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat res;
    
    if (indexPath.row == self.dataSource.count-2 || indexPath.row == 0)
    {
        CGFloat  h1 = self.view.frame.size.height;
        CGFloat  y1 = tableView.frame.origin.y;
        CGFloat  n  = _dataSource.count - 2;
        
        CGFloat r = (h1 - y1 - n * CELLHEIGHT_DEFAULT) / 2;
        
        res = r;
    }
    else
    {
        res = CELLHEIGHT_DEFAULT;
    }
    
    return res;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [self cellAtIndexPath:indexPath tableview:tableView];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row != self.dataSource.count-2 && indexPath.row != 0)
    {
        UILabel     *labelTitle =  (UILabel *) [cell viewWithTag:TAG_TITLE_LABEL];
        NSDictionary      *data = [self objectAtIndexPath:indexPath];
        labelTitle.text         = data[kFMASideMenuItemTitleKey];
        
        if (indexPath.row == 1 || indexPath.row == _dataSource.count - 1)
        {
            labelTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"tableView: didSelectRowAtIndexPath:"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != self.dataSource.count-2 && indexPath.row != 0)
    {
        NSDictionary *item = [self objectAtIndexPath:indexPath];
        [_delegate sideMenuVCDidSelectItemTitle:item[kFMASideMenuItemTitleKey]];
    }
}

@end
