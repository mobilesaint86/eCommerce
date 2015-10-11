//
//  FMABackgroundUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 10/6/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMABackgroundUtil.h"
#import "FMAConstants.h"
#import "FMAData.h"
#import "FMAUtil.h"
#import "UIImage+ResizeAdditions.h"
#import "FMABackgroundSetting.h"

@implementation FMABackgroundUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMABackgroundUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSString *)imagePathDir
{
    NSString *imageDir = [NSString stringWithFormat:@"%@/Documents/Images", NSHomeDirectory()];
    return imageDir;
}

+ (NSString *)fileNameForBackgroundName:(NSString *)backgroundName
{
    [self printLogWith:@"fileNameForBackgroundName"];
    
    NSString *suffix = @"PNG";
    
    NSString *temp   = [FMAUtil randomStringWithLength:10];
    
    NSString *res = [NSString stringWithFormat:@"%@_%@.%@", backgroundName, temp, suffix];
    
    return res;
}

+ (NSDictionary *)notificationObjectWithImage:(UIImage *)image forBackgroundName:(NSString *)backgroundName
{
    NSDictionary *res = @{kFMBackgroundNameKey:backgroundName, kFMBackgroundImageKey:image};
    return res;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Image Functions
+ (UIImage *)resizeImage:(UIImage *)image
{
    [self printLogWith:@"productImageFromImage"];
    
    // Check image width or height overflows the size
//    if ([FMAUtil checkImage:image outOfSize:size])
//    {
//        return [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
//                                           bounds:size
//                             interpolationQuality:kCGInterpolationMedium];
//    }
    
    return image;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestBackgroundForName:(NSString *)backgroundName delegate:(id<FMABackgroundUtilDelegate>)delegate
{
    [self printLogWith:@"requestBackgroundImageForName"];
    
    PFQuery *query = [PFQuery queryWithClassName:kFMBackgroundClassKey];
    [query whereKey:kFMBackgroundNameKey equalTo:backgroundName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error)
        {
            [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
        }
        else
        {
            PFObject *object = objects[0];
            
            PFFile *file = object[kFMBackgroundImageKey];
            
            FMABackgroundSetting *setting = [FMABackgroundSetting sharedInstance];
            
            if ([setting checkFileName:file.name forBackgroundName:backgroundName])
            {
                UIImage *res = [setting imageForBackgroundName:backgroundName];
                [delegate requestBackgroundForNameDidRespondWithImage:res isNew:NO];
            }
            else
            {
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
                 {
                     if (error)
                     {
                         [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
                     }
                     else
                     {
                         UIImage *res = [UIImage imageWithData:data];
                         [setting saveImage:res withFileName:file.name forBackgroundName:backgroundName];
                         [delegate requestBackgroundForNameDidRespondWithImage:res isNew:YES];
                     }
                 }];
            }
        }
    }];
}

@end
