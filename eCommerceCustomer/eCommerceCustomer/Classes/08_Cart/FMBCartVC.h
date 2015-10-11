//
//  FMBCartVC.h
//  eCommerceCustomer
//
//  Created by Albert Chen on 9/8/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FMBCartVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

// --------------------------------------------------------------------------------------
@property (strong, 	nonatomic)      PFImageView *imageviewBackground;

// ---------------------------------------------------------------------------------
@property (weak,    nonatomic) IBOutlet     UIView          *viewBack1;
@property (weak,    nonatomic) IBOutlet     UIView          *viewBack2;
@property (weak,    nonatomic) IBOutlet     UITableView     *tableview;

@property (strong,  nonatomic) IBOutletCollection(UIButton) NSArray *btnOptions;

@end
