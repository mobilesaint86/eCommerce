//
//  FMASideMenuVC.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/19/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMASideMenuVC;
// ----------------------------------------------------------------------------------------
// FMASideMenuVCDelegate Protocol
// ----------------------------------------------------------------------------------------
@protocol FMASideMenuVCDelegate <NSObject>

- (void)sideMenuVCDidSelectItemTitle:(NSString *)itemTitle;

@end

// ----------------------------------------------------------------------------------------
// FMASideMenuVC Class
// ----------------------------------------------------------------------------------------
@interface FMASideMenuVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic) id<FMASideMenuVCDelegate> delegate;
@property (strong,  nonatomic) NSArray *dataSource;

// ----------------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet UIImageView        *imageviewBackground;
@property (weak,    nonatomic) IBOutlet UITableView        *tableview;

// ----------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (CGSize)menuSize;
- (void)updateViewBackground;

@end
