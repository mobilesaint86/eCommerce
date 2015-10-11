//
//  FMBCoreLocationController.h
//  eCommerceCustomer
//
//  Created by Albert Chen on 9/24/14.
//  Copyright (c) 2014 Albert Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

// -----------------------------------------------------------------------------------
// FMBCoreLocationControllerDelegate Protocol
// -----------------------------------------------------------------------------------
@protocol FMBCoreLocationControllerDelegate

@required
- (void)locationUpdateWithGeoPoint:(PFGeoPoint *)geoPoint;
- (void)locationError:(NSError *)error;

@end

// -----------------------------------------------------------------------------------
// FMBCoreLocationController Class
// -----------------------------------------------------------------------------------
@interface FMBCoreLocationController : NSObject<CLLocationManagerDelegate>

// -----------------------------------------------------------------------------------
@property (strong, nonatomic) id<FMBCoreLocationControllerDelegate> delegate;

@property (strong, nonatomic) NSTimer           *timer;

// -----------------------------------------------------------------------------------
- (void)startUpdateLocation;
- (void)stopUptateLocation;

@end
