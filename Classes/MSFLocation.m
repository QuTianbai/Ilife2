//
//  MSFLocation.m
//  Finance
//
//  Created by xbm on 15/7/30.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFLocation.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MSFLocationModel.h"
#import "MSFClient+MSFLocation.h"

@interface MSFLocation ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MSFLocation

- (id)init {
  if (self = [super init]) {
    
    
  }
  
  return self;
}

- (void)startLocation {
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  [self.locationManager requestAlwaysAuthorization];
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  self.locationManager.distanceFilter = 100;
  [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  switch (status) {
    case kCLAuthorizationStatusNotDetermined:
      if ([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [manager requestAlwaysAuthorization];
      }
      break;
      
    default:
      break;
  }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *location = [locations lastObject];
  NSDate *eventDate = location.timestamp;
  NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
  
  //if (fabs(howRecent)<15.0) {
    if ([self.delegate respondsToSelector:@selector(getLocationCoordinate:)]) {
      [self.delegate getLocationCoordinate:location.coordinate];
    }
 // }
  
}

@end
