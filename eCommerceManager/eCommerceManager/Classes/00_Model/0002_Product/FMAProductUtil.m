//
//  FMAProductUtil.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/15/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMAProductUtil.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMAUtil.h"
#import "UIImage+ResizeAdditions.h"

@implementation FMAProductUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMAERegisterUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Image Functions
+ (UIImage *)productImageFromImage:(UIImage *)image bySize:(CGSize)size
{
    [self printLogWith:@"productImageFromImage"];
    
    // Check image width or height overflows the size
    if ([FMAUtil checkImage:image outOfSize:size])
    {
        return [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                            bounds:size
                                              interpolationQuality:kCGInterpolationLow];
    }
    
    return image;
}

@end
