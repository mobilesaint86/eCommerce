//
//  FMABackgroundSetting.h
//  eCommerceManager
//
//  Created by Albert Chen on 10/6/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FMABackgroundSetting : NSObject<NSCoding>

// --------------------------------------------------------------------------------------
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;

// --------------------------------------------------------------------------------------
@property (strong,  nonatomic)  NSMutableDictionary  *fileNames;
@property (strong,  nonatomic)  NSMutableDictionary  *blurImages;

// --------------------------------------------------------------------------------------
#pragma mark - Singleton Mehtod
+ (id)sharedInstance;

// --------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (BOOL)checkFileName:(NSString *)fileName forBackgroundName:(NSString *)backgroundName;
- (NSString *)fileNameForBackgroundName:(NSString *)backgroundName;
- (void)store;
- (UIImage *)imageForBackgroundName:(NSString *)backgroundName;
- (void)saveImage:(UIImage *)image withObject:(PFObject *)object;
- (void)saveImage:(UIImage *)image withFileName:(NSString *)fileName forBackgroundName:(NSString *)backgroundName;

// --------------------------------------------------------------------------------------
#pragma mark - Blur Image Functions
- (void)configureBlurImages;
- (UIImage *)blurImageForBackgroundName:(NSString *)backgroundName;

@end
