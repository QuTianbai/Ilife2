//
//  MSFClient+MSFLocation.m
//  Finance
//
//  Created by xbm on 15/7/30.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFLocation.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFLocation.h"
#import <AFNetworking/AFNetworking.h>
#import "MSFObject.h"
#import "MSFLocationModel.h"

@implementation MSFClient (MSFLocation)

- (RACSignal *)fetchLocationAdress:(CLLocationCoordinate2D)coordinate {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?ak=sTLArkR5mCiQrGcflln8li7c&callback=renderReverse&location=%f,%f&output=json&pois=1", coordinate.latitude, coordinate.longitude]];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  return [self enqueueRequestCustom:request resultClass:MSFLocationModel.class];
  
}

@end
