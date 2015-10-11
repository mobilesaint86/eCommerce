//
//  FMAChooseBankVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/30/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAChooseBankVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMAERegisterUtil.h"
#import "FMABackgroundSetting.h"

#define CELLID          @"ChooseBankCell"

@interface FMAChooseBankVC ()

@end

@implementation FMAChooseBankVC
{
    NSArray *_bankList;
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAChooseBankVC) return;
    
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


- (void)viewDidLayoutSubviews
{
    [self printLogWith:@"viewDidLayoutSubviews"];
    [super viewDidLayoutSubviews];
    
    [FMAThemeManager relayoutTableviewForApp:self.tableView];
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
    
    [self initTheme];
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    _bankList = [FMAERegisterUtil bankList];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    [self initViewBackground];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:_backgroundName toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:_backgroundName delegate:self];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMAThemeManager setBackgroundImageForName:_backgroundName toImageView:_imageviewBackground];
    }
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// -------------------------------------------------------------------------------------------------------------------------
#pragma mark - TableView Delegate Functions
- (FMABank *)objectAtIndexPath:(NSIndexPath *)indexPath
{
    return [_bankList objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_bankList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    
    FMABank *bank = [self objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [bank displayTitle];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self printLogWith:@"tableView didSelectRowAtIndexPath"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate chooseBankVC:self didSelectBank:[self objectAtIndexPath:indexPath]];
}

@end
