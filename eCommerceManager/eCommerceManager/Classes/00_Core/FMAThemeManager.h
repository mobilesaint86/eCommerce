//
//  FMAThemeManager.h
//  eCommerceManager
//
//  Created by Albert Chen on 8/18/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMAData.h"
#import "FMAUtil.h"
#import "JSQMessages.h"

@interface FMAThemeManager : NSObject

// ---------------------------------------------------------------------------------------
#pragma mark - Theme Init Functions
+ (void)initAppTheme;

// ---------------------------------------------------------------------------------------
#pragma mark - Image Blur Functions
+ (UIImage *)snapshotImageFromVC:(UIViewController *)vc;
+ (UIImage *)blurImageCopiedFromVC:(UIViewController *)vc;
+ (UIImage *)blurImageForMainPagesFromImage:(UIImage *)originalImage atFrame:(CGRect)frame;

// Main Page Image Function
+ (UIImage *)blurImageForMainPageByImage:(UIImage *)image;
+ (UIImage *)blurImageForMainPageNavigationBarByImage:(UIImage *)image;
+ (UIImage *)blurImageForMainPageToolbarByImage:(UIImage *)image;
+ (UIImage *)blurImageForMainPageNavigationBarWithPromptByImage:(UIImage *)image;

// SideMenu Page Blur Image
+ (UIImage *)blurImageForSideMenuByImage:(UIImage *)image;

// ---------------------------------------------------------------------------------------
#pragma mark - NavigationBar, Toolbar Functions
+ (void)makeTransparentNavigationBar:(UINavigationBar *)navigationBar;
+ (void)makeTransparentToolBar:(UIToolbar *)toolbar;
+ (void)makeTransparentSearchBar:(UISearchBar *)searchBar;

// ---------------------------------------------------------------------------------------
#pragma mark - UI Functions
// Functions of Adjusting Position, Size, etc
+ (void)setViewFrameWith:(UIView *)v X:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)w Height:(CGFloat)h;
+ (void)adjustViewHeight:(UIView *)view mainFrame:(CGRect)mainFrame;

// Functions of Decorating Controls With Radius, Shadow, Border, etc
#pragma mark -
+ (void)setCornerRadiusToView:(UIView *)view Radius:(CGFloat)radius;
+ (void)setBorderToView:(UIView *)view Width:(CGFloat)borderWidth Color:(UIColor *)borderColor Radius:(CGFloat)radius;
+ (void)setBorderToView:(UIView *)view Width:(CGFloat)borderWidth Color:(UIColor *)borderColor Radius:(CGFloat)radius showShadow:(BOOL)bShowShadow;
+ (void)setShadowToView:(UIView *)view cornerRadius:(CGFloat)cornerRadius;
+ (void)setBorderToView:(UIView *)view width:(CGFloat)width Color:(UIColor *)color;
+ (void)decorateButton:(UIButton *)button;
+ (void)decorateButton3:(UIButton *)button;
+ (void)decorateTextFieldContainer:(UIView *)view;
+ (void)decorateInputAccessoryViewBarButton:(UIBarButtonItem *)button textColor:(UIColor *)textColor;
+ (void)decorateInputAccessoryViewBarButton:(UIBarButtonItem *)button withSelector:(SEL)selector;
+ (void)setPlaceholder:(NSString*)string toTextField:(UITextField *)textField color:(UIColor *)color;
+ (void)makeCircleWithView:(UIView *)view;
+ (void)makeCircleWithView:(UIView *)view borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
+ (void)removeHeaderSpaceInTableView:(UITableView *)tableView;

// TableViewCell ContentView Background
+ (void)decorateEvenOddStyleForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath cellColor:(UIColor *)cellColor;

// ---------------------------------------------------------------------------------------
#pragma mark - Background Functions
+ (PFImageView *)createBackgroundImageViewForVC:(UIViewController *)vc withBottomBar:(UIToolbar *)toolbar;
+ (PFImageView *)createBackgroundImageViewForTableVC:(UITableViewController *)vc
                                       withBottomBar:(UIToolbar *)toolbar;
+ (PFImageView *)createBackgroundImageViewForMessageVC:(JSQMessagesViewController *)vc;
+ (void)setBackgroundImageForName:(NSString *)backgroundName toImageView:(UIImageView *)imageview;
+ (void)setBackgroundImageForName:(NSString *)backgroundName toNavigationBar:(UINavigationBar *)navBar withPrompt:(BOOL)bPrompt;
+ (void)relayoutTableviewForApp:(UITableView *)tableview;

@end
