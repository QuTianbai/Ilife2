//
// MSFAFViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFFormsViewModel.h"
#import "MSFClient.h"
#import "MSFUser.h"
#import "MSFServer.h"

// Model
#import "MSFApplyInfo.h"
#import "MSFCheckEmployee.h"

// Vendor
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


QuickSpecBegin(MSFAFViewModelSpec)

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

__block MSFFormsViewModel *viewModel;
__block MSFClient *client;

beforeEach(^{
	MSFUser *user = mock(MSFUser.class);
	stubProperty(user, server, MSFServer.dotComServer);
	stubProperty(user, objectID, @"1");
	client = [MSFClient authenticatedClientWithUser:user token:@"" session:@""];
	viewModel = [[MSFFormsViewModel alloc] initWithClient:client];
});

it(@"should initialize", ^{
  // then
	expect(viewModel).notTo(beNil());
	expect(viewModel.client).notTo(beNil());
	expect(@(viewModel.client.isAuthenticated)).to(beTruthy());
});

it(@"should get model market", ^{
  // given
	stubResponse(@"/loans/spec",@"loaninfo.json");
	stubResponse(@"/users/1/check_employee",@"checkemployee.json");
	viewModel.active = YES;
	
  // when
	[viewModel.updatedContentSignal asynchronousFirstOrDefault:nil success:nil error:nil];
	
  // then
	expect(viewModel.model).notTo(beNil());
	expect(viewModel.market).notTo(beNil());
});

it(@"should get error when not get model or market", ^{
  // given
	stubResponseWithHeaders(@"/loans/spec", @"error.json", 404, @{
		@"Content-Type": @"application/json"
	});
	stubResponse(@"/users/1/check_employee",@"checkemployee.json");
//	stubResponseWithHeaders(@"/users/1/check_employee", @"error.json", 404, @{
//		@"Content-Type": @"application/json"
//	});
	NSError *error = nil;
	BOOL success = NO;
	viewModel.active = YES;
	
  // when
	[viewModel.updatedContentSignal asynchronousFirstOrDefault:nil success:&success error:&error];
	
  // then
	expect(@(success)).to(beFalsy());
	expect(error).notTo(beNil());
});

QuickSpecEnd
