//
//  FMACoreLocationController.m
//  eCommerceManager
//
//  Created by Albert Chen on 9/14/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import "FMACoreLocationController.h"
#import "FMAData.h"
#import "FMAUtil.h"
#import "FMAConstants.h"
#import "LMGeocoder.h"

// Interval in seconds to check if need to sync (keeps checking at this interval until successful sync)
#define CHECK_INTERVAL 600.0

@implementation FMACoreLocationController

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMACoreLocationController) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - LifeCycle Functions
- (id)init
{
    [self printLogWith:@"init"];
    
    self = [super init];
    
    if(self != nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        self.locationManager.delegate = self;
    }
    
    return self;
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
}

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (void)startUpdateLocation
{
    [self printLogWith:@"startUpdateLocation"];
    
    [self runLocationManager:nil];
    [self start];
}

- (void)stopUptateLocation
{
    [self printLogWith:@"stopUptateLocation"];
    
    [self.timer invalidate];
    self.timer = nil;
    
    [self.locationManager stopUpdatingLocation];
}

- (void)start
{
    [self printLogWith:@"start"];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:CHECK_INTERVAL
                                                  target:self
                                                selector:@selector(runLocationManager:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)runLocationManager:(id)sender
{
    [self printLogWith:@"runLocationManager"];
    
    [self.locationManager startUpdatingLocation];
}

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)locationManager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self printLogWith:@"locationManager: didUpdateToLocation"];
    
    [_locationManager stopUpdatingLocation];
    
    [self.delegate locationUpdate:newLocation];
}

- (void)locationManager:(CLLocationManager *)locationManager didFailWithError:(NSError *)error
{
    [self printLogWith:@"locationManager: didFailWithError"];
    [self.delegate locationError:error];
}

@end
