//
//  FMABackgroundSetting.m
//  eCommerceManager
//
//  Created by Albert Chen on 10/6/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMABackgroundSetting.h"
#import "FMAUtil.h"
#import "FMAData.h"
#import "FMAConstants.h"
#import "FMABackgroundUtil.h"
#import "FMAThemeManager.h"

#define FILE_NAMES_CODING_KEY                     @"backgroundsetting_file_names"

@implementation FMABackgroundSetting

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMABackgroundSetting) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (void)printLogWith:(NSString *)logMessage
{
    [FMABackgroundSetting printLogWith:logMessage];
}
// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Singleton Mehtod
+ (id)sharedInstance
{
    [self printLogWith:@"sharedInstance"];
    
    static FMABackgroundSetting *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if ([FMAUtil checkKeyExistInAppSettings:APP_SETTING_KEY_BACKGROUND_SETTING])
        {
            sharedInstance = [self unarchivedObjectFromData:[FMAUtil appSettingValueByKey:APP_SETTING_KEY_BACKGROUND_SETTING]];
        }
        else
        {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

// -----------------------------------------------------------------------------------------------------------------------------
#pragma mark - LifeCycle Functions
- (id)init
{
    self = [super init];
    
    if (self)
    {
        _fileNames = [[NSMutableDictionary alloc] init];
        
        // create folder for images
        NSError *error;
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[FMABackgroundUtil imagePathDir] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return self;
}

// -----------------------------------------------------------------------------------------------------------------------------
#pragma mark - NSCoding Functions
- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self printLogWith:@"initWithCoder"];
    
    self = [super init];
    
    if (self)
    {
        _fileNames  = [aDecoder decodeObjectForKey:FILE_NAMES_CODING_KEY];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self printLogWith:@"encodeWithCoder"];
    
    [aCoder encodeObject:_fileNames forKey:FILE_NAMES_CODING_KEY];
}

// -----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (NSData *)archivedObject
{
    [self printLogWith:@"archivedObject"];
    
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (FMABackgroundSetting *)unarchivedObjectFromData:(NSData *)data
{
    [self printLogWith:@"unarchivedObjectFromData"];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)store
{
    [self printLogWith:@"store"];
    
    [FMAUtil setAppSettingValue:[self archivedObject] ByKey:APP_SETTING_KEY_BACKGROUND_SETTING];
}

// -----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Main Functions
- (BOOL)checkFileName:(NSString *)fileName forBackgroundName:(NSString *)backgroundName
{
    NSString *name1 = [self fileNameForBackgroundName:backgroundName];
    
    BOOL res = [name1 isEqualToString:fileName];
    
    return res;
}

- (NSString *)fileNameForBackgroundName:(NSString *)backgroundName
{
    NSString *fileName = [_fileNames objectForKey:backgroundName];
    return fileName;
}

- (UIImage *)imageForBackgroundName:(NSString *)backgroundName
{
    NSString *fileName = [self fileNameForBackgroundName:backgroundName];
    
    UIImage *res;
    
    if (fileName)
    {
        NSString *fullPath  = [NSString stringWithFormat:@"%@/%@", [FMABackgroundUtil imagePathDir], fileName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSData *imageData = [fileManager contentsAtPath:fullPath];
        
        res = [UIImage imageWithData:imageData];
        
        if (!res)
        {
            res = [UIImage imageNamed:COMMON_IMAGE_BACKGROUND];
        }
    }
    else
    {
        res = [UIImage imageNamed:COMMON_IMAGE_BACKGROUND];
    }
    
    return res;
}

- (void)saveImage:(UIImage *)image withObject:(PFObject *)object
{
    [self printLogWith:@"saveImage: forBackgroundName:"];
    
    // 1. Generate file name
    NSString *fileName = [FMABackgroundUtil fileNameForBackgroundName:object[kFMBackgroundNameKey]];
    
    // 2. Save image with file name
    // 3. Change file name in _filenames and reset the blur image
    [self saveImage:image withFileName:fileName forBackgroundName:object[kFMBackgroundNameKey]];
    
    // 4. Save the image to the object and upload to Parse
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    NSData *imageData  = UIImagePNGRepresentation(image);
    PFFile *file       = [PFFile fileWithName:fileName data:imageData];
    
    object[kFMBackgroundImageKey] = file;
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error)
         {
             [self printLogWith:[FMAUtil errorStringFromParseError:error WithCode:YES]];
         }
         else
         {
             [self printLogWith:@"- Image Uploaded Successfully."];
         }
         
         [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
     }];
}

// -----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Main() Functions
- (void)saveImage:(UIImage *)image withFileName:(NSString *)fileName forBackgroundName:(NSString *)backgroundName
{
    [self saveImage:image withFileName:fileName];
    [self setNewFileName:fileName forBackgroundName:backgroundName];
    [self setBlurImageFromImage:image forBackgroundName:backgroundName];
}

- (void)saveImage:(UIImage *)image withFileName:(NSString *)fileName
{
    NSString *fullPath  = [NSString stringWithFormat:@"%@/%@", [FMABackgroundUtil imagePathDir], fileName];
    
    NSData *data = UIImagePNGRepresentation(image);
    
    [data writeToFile:fullPath atomically:YES];
}

- (void)setNewFileName:(NSString *)fileName forBackgroundName:(NSString *)backgroundName
{
    NSString *oldFileName = [_fileNames objectForKey:backgroundName];
    
    // Check the image exists for a background name and delete
    if (oldFileName)
    {
        NSString *fullPath  = [NSString stringWithFormat:@"%@/%@", [FMABackgroundUtil imagePathDir], oldFileName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:fullPath])
        {
            [fileManager removeItemAtPath:fullPath error:nil];
        }
    }
    
    // Save new file name
    [_fileNames setObject:fileName forKey:backgroundName];
    [self store];
}

- (UIImage *)setBlurImageFromImage:(UIImage *)image forBackgroundName:(NSString *)backgroundName
{
    UIImage *blurImage = [FMAThemeManager blurImageForMainPageByImage:image];
    [_blurImages setObject:blurImage forKey:backgroundName];
    
    return blurImage;
}

// -----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Blur Image Functions
- (void)configureBlurImages
{
    [self printLogWith:@"configureBlurImages"];
    
    _blurImages = [[NSMutableDictionary alloc] init];
    
    // Configure the default blur image
    UIImage *defaultBlurredImage = [self setBlurImageFromImage:[UIImage imageNamed:COMMON_IMAGE_BACKGROUND]
                                             forBackgroundName:kFMBackgroundNameDefault];
    
    // Configure the other blur images
    NSArray *names = @[kFMBackgroundNameLogin, kFMBackgroundNameDashboard, kFMBackgroundNameStore, kFMBackgroundNameMessages,
                       kFMBackgroundNameERegister, kFMBackgroundNameSettings];
    
    for (NSString *backgroundName in names)
    {
        NSString *fileName = [self fileNameForBackgroundName:backgroundName];
        
        UIImage *blurImage;
        
        if (fileName)
        {
            NSString         *fullPath = [NSString stringWithFormat:@"%@/%@", [FMABackgroundUtil imagePathDir], fileName];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            NSData *imageData = [fileManager contentsAtPath:fullPath];
            UIImage       *tt = [UIImage imageWithData:imageData];
            
            if (!tt)
            {
                blurImage = defaultBlurredImage;
            }
            else
            {
                blurImage = [FMAThemeManager blurImageForMainPageByImage:tt];
            }
        }
        else
        {
            blurImage = defaultBlurredImage;
        }
        
        [_blurImages setObject:blurImage forKey:backgroundName];
    }
}

- (UIImage *)blurImageForBackgroundName:(NSString *)backgroundName
{
    UIImage *res = [_blurImages objectForKey:backgroundName];
    return res;
}

@end
