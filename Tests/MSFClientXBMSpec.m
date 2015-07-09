//
//  MSFClientXBMSpec.m
//  Cash
//
//  Created by xbm on 15/5/15.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "MSFClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <Mantle/Mantle.h>

#import "MSFServer.h"
#import "MSFResponse.h"

#import "MSFAdver.h"
#import "MSFClient+Adver.h"

#import "MSFApplicationForms.h"
#import "MSFClient+MSFApplyInfo.h"

#import "MSFApplyList.h"
#import "MSFClient+ApplyList.h"

#import "MSFApplicationResponse.h"
#import "MSFClient+MSFApplyCash.h"


QuickSpecBegin(MSFClientXBMSpec)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"

void (^stubResponseWithHeaders)(NSString *, NSString *, int, NSDictionary *) = ^(NSString *path, NSString *responseFilename, int statusCode, NSDictionary *headers) {
    if (responseFilename != nil) {
        headers = [headers mtl_dictionaryByAddingEntriesFromDictionary:@{@"Content-Type": @"application/json"}];
    }
    
    [OHHTTPStubs addRequestHandler:^ id (NSURLRequest *request, BOOL onlyCheck) {
        if (![request.URL.path isEqual:path]) return nil;
        
        if (responseFilename == nil) {
            return [OHHTTPStubsResponse responseWithData:[NSData data] statusCode:statusCode responseTime:0 headers:headers];
        } else {
            NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:responseFilename.stringByDeletingPathExtension withExtension:responseFilename.pathExtension];
            return [OHHTTPStubsResponse responseWithFileURL:fileURL statusCode:statusCode responseTime:0 headers:headers];
        }
    }];
};

void (^stubResponse)(NSString *, id) = ^(NSString *path, id response) {
    if ([response isKindOfClass:[NSDictionary class]] || [response isKindOfClass:[NSArray class]]) {
        [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
            if (![request.URL.path isEqual:path]) return nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:nil];
            return [OHHTTPStubsResponse responseWithData:data statusCode:200 responseTime:0 headers:@{@"Content-Type": @"application/json"}];
        }];
        return;
    }
    stubResponseWithHeaders(path, response, 200, @{});
};

void (^stubRedirectResponseURL)(NSURL *, int, NSURL *) = ^(NSURL *URL, int statusCode, NSURL *redirectURL) {
    [OHHTTPStubs addRequestHandler:^ id (NSURLRequest *request, BOOL onlyCheck) {
        if (!([request.URL.scheme isEqual:URL.scheme] && [request.URL.path isEqual:URL.path])) return nil;
        
        return [OHHTTPStubsResponse responseWithData:[NSData data] statusCode:statusCode responseTime:0 headers:@{@"Location": redirectURL.absoluteString}];
    }];
};

void (^stubResponseURL)(NSURL *, NSString *, int, NSDictionary *) = ^(NSURL *URL, NSString *responseFilename, int statusCode, NSDictionary *headers) {
    headers = [headers mtl_dictionaryByAddingEntriesFromDictionary:@{@"Content-Type": @"application/json"}];
    
    [OHHTTPStubs addRequestHandler:^ id (NSURLRequest *request, BOOL onlyCheck) {
        if (![request.URL isEqual:URL]) return nil;
        
        NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:responseFilename.stringByDeletingPathExtension withExtension:responseFilename.pathExtension];
        return [OHHTTPStubsResponse responseWithFileURL:fileURL statusCode:statusCode responseTime:0 headers:headers];
    }];
};
#pragma clang diagnostic pop

__block MSFClient *client;
__block BOOL success;
__block NSError *error;

beforeEach(^{
    client = [[MSFClient alloc] initWithServer:MSFServer.dotComServer];
    success = NO;
    error = nil;
});
it(@"should initialize", ^{
    // then
    expect(client).notTo(beNil());
});

it(@"should fetch adver", ^{
    // given
    stubResponse(@"/ads/home",@"adver.json");
    
    // when
    RACSignal *request = [client fetchAdverWithCategory:@"0"];
    MSFAdver *adver = [request asynchronousFirstOrDefault:nil success:nil error:nil];
    
    // then
   expect(adver).to(beAKindOf(MSFAdver.class));
});
it(@"should fetch applyInfo", ^{
    // given
    stubResponse(@"/loans/spec",@"applyInfo.json");
    
    // when
    RACSignal *request = [client fetchApplyInfo];
    MSFApplicationForms *applyInfo = [request asynchronousFirstOrDefault:nil success:nil error:nil];
    
    // then
    expect(applyInfo).to(beAKindOf([MSFApplicationForms class]));
});

it(@"should fetch applyList", ^{
    // given
    stubResponse(@"/loans",@"applyList.json");
    
    // when
    RACSignal *request = [client fetchApplyList];
    MSFApplyList *applyList = [request asynchronousFirstOrDefault:nil success:nil error:nil];
    
    // then
    expect(applyList).to(beAKindOf(MSFApplyList.class));
});
it(@"should fetch cash", ^{
    // given
    stubResponse(@"/loans",@"applycash.json");
    
    // when
    RACSignal *request = [client fetchApplyCash];
    MSFApplicationResponse *applyCash = [request asynchronousFirstOrDefault:nil success:nil error:nil];
    
    // then
    expect(applyCash).to(beAKindOf([MSFApplicationResponse class]));
});

xit(@"should fetch applyinfo",^{
   stubResponse(@"/loans",@"loadinfo.json");
  NSURLRequest *request = [client requestWithMethod:@"POST" path:@"/loans" parameters:nil];
  
  // when
  RACSignal *result = [client enqueueRequest:request resultClass:MSFApplicationForms.class];
  MSFResponse *response = [result asynchronousFirstOrDefault:nil success:&success error:&error];
  
  expect(response).notTo(beNil());
  expect(response.parsedResult).to(beAKindOf([MSFApplicationForms class]));
  expect([[response parsedResult] workingLength]).to(equal(@"WE03"));
});

QuickSpecEnd