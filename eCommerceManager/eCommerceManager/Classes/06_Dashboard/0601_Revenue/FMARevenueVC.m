//
//  FMARevenueVC.m
//  eCommerceManager
//
//  Created by Albert Chen on 8/22/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMARevenueVC.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "FMAThemeManager.h"
#import "FMABackgroundSetting.h"

@interface FMARevenueVC ()

@end

@implementation FMARevenueVC
{
    NSMutableArray *dataSource;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMARevenueVC) return;
    
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
//    [self initGraphViewDataSource];
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
    
    [self initDateBarButton];
    
    [self initTabView];
    [self initGraphView];
    
    _hud = [FMAUtil initHUDWithView:self.view];
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMAThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMAThemeManager setBackgroundImageForName:kFMBackgroundNameDashboard toImageView:_imageviewBackground];
    
    [FMABackgroundUtil requestBackgroundForName:kFMBackgroundNameDashboard delegate:self];
}

- (void)initTabView
{
    [self printLogWith:@"initTabView"];
    
    _tabView.delegate = self;
    [_tabView setSelectedIndex:0];
}

- (void)initDateBarButton
{
    [self printLogWith:@"initDateBarButton"];
    
    NSString *string = [FMAUtil stringFromDate:[NSDate date] WithFormat:@"MMM YYYY"];
    
    [_barButtonDate setTitle:string];
}

- (void)initGraphView
{
    [self printLogWith:@"initGraphView"];
    
    _graph.colorTop                     = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:.2];
    _graph.colorBottom                  = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:.2];
    _graph.colorLine                    = [UIColor whiteColor];
    _graph.colorXaxisLabel              = [UIColor whiteColor];
    _graph.colorYaxisLabel              = [UIColor whiteColor];
    _graph.widthLine                    = 1.5;
    _graph.enableTouchReport            = YES;
    _graph.enablePopUpReport            = YES;
    _graph.enableBezierCurve            = NO;
    _graph.enableYAxisLabel             = YES;
    _graph.autoScaleYAxis               = YES;
    _graph.alwaysDisplayDots            = NO;
    _graph.enableReferenceAxisLines     = YES;
    _graph.enableReferenceAxisFrame     = YES;
    _graph.animationGraphStyle          = BEMLineAnimationNone;
    _graph.animationGraphEntranceTime   = 0;
}

- (void)updateLabelTotal
{
    [self printLogWith:@"updateLabelTotal"];
    
    _labelTotal.text = [NSString stringWithFormat:@"$%.2f", [FMARevenueUtil totalSumFromDataSource:dataSource]];
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
#pragma mark - Data Source Init Functions
- (void)initGraphViewDataSource
{
    [self printLogWith:@"initGraphViewDataSource"];
    
    _ArrayOfValues  = [[NSMutableArray alloc] init];
    _ArrayOfDates   = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 31; i++)
    {
        // Random values for the graph
        [self.ArrayOfValues addObject:[NSNumber numberWithInteger:(arc4random() % 10000)]];
        
        // Dates for the X-Axis of the graph
        [self.ArrayOfDates addObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:1 + i]]];
    }
}

- (void)initDisplayValuesByDataRevenues:(NSArray *)revenues
{
    [self printLogWith:@"initDisplayValuesByDataRevenues"];
    
    _ArrayOfValues  = [[NSMutableArray alloc] init];
    _ArrayOfDates   = [[NSMutableArray alloc] init];
    
    for (NSDictionary *data in revenues)
    {
        // Random values for the graph
        [self.ArrayOfValues addObject:data[kFMRevenueSumKey]];
        
        // Dates for the X-Axis of the graph
        [self.ArrayOfDates addObject:[NSString stringWithFormat:@"%@", data[kFMRevenueLabelKey]]];
    }
}

- (void)initDataSource
{
    [self printLogWith:@"initDataSource"];
    
    dataSource = [FMARevenueUtil initDataSourceForType:[FMARevenueUtil dataSourceTypeByTabIndex:_tabView.selectedIndex]];
    
    [self initDisplayValuesByDataRevenues:dataSource];
    
    [FMARevenueUtil requestGetRevenueGraphData:dataSource delegate:self];
    
    [FMAUtil showHUD:_hud withText:@""];
    
    [self updateLabelTotal];
}

- (void)requestGetRevenueGraphDataDidRespondWithRevenues:(NSArray *)revenues
{
    [self printLogWith:@"requestGetRevenueGraphDataDidRespondWithRevenues"];
    
    [_hud hide:YES];
    
    dataSource = [[NSMutableArray alloc] initWithArray:revenues];
    
    [self initDisplayValuesByDataRevenues:dataSource];
    
    [_graph reloadGraph];
    
    [self updateLabelTotal];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnBack:(id)sender
{
    [self printLogWith:@"onBtnBack"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMATabViewDelegate Functions
- (void)tabView:(FMATabView *)tabView didSelectItemAtIndex:(NSInteger)index
{
    [self printLogWith:@"tabView: didSelectItemAtIndex"];
    
    [self initDataSource];
    [_graph reloadGraph];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - SimpleLineGraph Data Source
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
    return (int)[self.ArrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index
{
    return [[self.ArrayOfValues objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate
- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    return 1;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index
{
    NSString *label = [self.ArrayOfDates objectAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index
{
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index
{
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph
{
}

@end
