//
// NSURLConnection+Locations.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface NSURLConnection (Locations)

+ (RACSignal *)fetchLocationWithLatitude:(double)latitude longitude:(double)longitude;

@end
