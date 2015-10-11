//
//  FMACoreLocationController.h
//  eCommerceManager
//
//  Created by Albert Chen on 9/14/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

// -----------------------------------------------------------------------------------
// FMACoreLocationControllerDelegate Protocol
// -----------------------------------------------------------------------------------
@protocol FMACoreLocationControllerDelegate

@required
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end

// -----------------------------------------------------------------------------------
// FMACoreLocationController Class
// -----------------------------------------------------------------------------------
@interface FMACoreLocationController : NSObject<CLLocationManagerDelegate>

// -----------------------------------------------------------------------------------
@property (strong, nonatomic) id<FMACoreLocationControllerDelegate> delegate;

@property (strong, nonatomic) NSTimer           *timer;
@property (strong, nonatomic) CLLocationManager *locationManager;

// -----------------------------------------------------------------------------------
- (void)startUpdateLocation;
- (void)stopUptateLocation;

@end
