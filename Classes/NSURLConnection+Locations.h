//
// NSURLConnection+Locations.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface NSURLConnection (Locations)

// Use to translate coordinate to address information <MSFLocationModel> instance
//
// When error the returns signal will send complete without error, This API use Baidu services API
//
// latitude  - The latitude
// longitude - The longitude
//
// Returns a signal will send <MSFLocationModel> instance
+ (RACSignal *)fetchLocationWithLatitude:(double)latitude longitude:(double)longitude __deprecated;

@end
