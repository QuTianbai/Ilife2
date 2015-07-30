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

@implementation MSFClient (MSFLocation)

- (RACSignal *)fetchLocationAdress:(CLLocationCoordinate2D)coordinate {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?ak=sTLArkR5mCiQrGcflln8li7c&callback=renderReverse&location=%f,%f&output=json&pois=1", coordinate.latitude, coordinate.longitude]];
  //NSURLRequest *request = [NSURLRequest requestWithURL:url];
  //NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
  NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET"
                                                                 URLString:url.absoluteString
                                                                parameters:nil
                                                                     error:nil];
  return [[self enqueueRequest:request resultClass:MSFLocation.class] msf_parsedResults];
  
}

//- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(id)parameters {
//  NSURL *URL = [NSURL URLWithString:path relativeToURL:self.baseURL];
//  NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method
//                                                                 URLString:URL.absoluteString
//                                                                parameters:nil
//                                                                     error:nil];
// // [request setAllHTTPHeaderFields:self.defaultHeaders];
//  
//  return request;
//}

@end
