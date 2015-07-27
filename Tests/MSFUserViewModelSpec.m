//
// MSFUserViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUserViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "MSFResponse.h"
#import "MSFUser.h"
#import "MSFClient.h"
#import "MSFServer.h"

QuickSpecBegin(MSFUserViewModelSpec)

__block MSFUserViewModel *viewModel = nil;

beforeEach(^{
  MSFUser *user = mock(MSFUser.class);
  stubProperty(user, objectID, @"xx");
  stubProperty(user, server, MSFServer.dotComServer);
  MSFClient *client = [MSFClient authenticatedClientWithUser:user token:@"xxx" session:@""];
//  viewModel = [[MSFUserViewModel alloc] initWithClient:client];
});

it(@"should initialize", ^{
  expect(viewModel).notTo(beNil());
//  expect(viewModel.client).notTo(beNil());
//  expect(viewModel.client.user.objectID).notTo(beNil());
});

it(@"should update user password", ^{
  // given
  viewModel.usedPassword = @"123456qw";
  viewModel.updatePassword = @"123457qx";
  [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"message" withExtension:@"json"];
    return [OHHTTPStubsResponse responseWithFileURL:URL statusCode:200 responseTime:0 headers:@{@"Content-Type": @"application/json"}];
  }];
  
  // when
  __block MSFResponse *response  = nil;
  [[viewModel.executeUpdatePassword.executionSignals concat] subscribeNext:^(id x) {
    response = x;
  }];
  [[viewModel.executeUpdatePassword execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
  
  // then
  expect(response.parsedResult[@"message"]).to(equal(@"send success"));
});

it(@"should can't update user password", ^{
  // given
  viewModel.usedPassword = @"123456";
  viewModel.updatePassword = @"1234";
  
  // when
  __block BOOL valid;
//  [viewModel.updateValidSignal subscribeNext:^(id x) {
//    valid = [x boolValue];
//  }];
	
  // then
  expect(@(valid)).to(beFalsy());
});

it(@"should has user information", ^{
  // given
  [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"authorizations" withExtension:@"json"];
    return [OHHTTPStubsResponse responseWithFileURL:URL statusCode:200 responseTime:0 headers:@{@"Content-Type": @"application/json"}];
  }];
  
  // when
  viewModel.active = YES;
  [viewModel.contentUpdateSignal asynchronousFirstOrDefault:nil success:nil error:nil];
  
  // then
  expect(viewModel.username).to(equal(@"xxx"));
  expect(viewModel.mobile).to(equal(@"15222222222"));
  expect(viewModel.identifyCard).to(equal(@"123"));
});

QuickSpecEnd
