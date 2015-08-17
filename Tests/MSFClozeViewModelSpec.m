//
// MSFProcedureViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClozeViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <UIKit/UIKit.h>
#import "MSFServer.h"
#import "MSFUser.h"
#import "MSFClient.h"
#import "MSFSelectKeyValues.h"
#import "MSFAddressViewModel.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

QuickSpecBegin(MSFClozeViewModelSpec)

__block MSFClozeViewModel *viewModel;
__block id <MSFViewModelServices> services;

beforeEach(^{
  MSFUser *user = mock(MSFUser.class);
  stubProperty(user, objectID, @"foo");
  stubProperty(user, server, MSFServer.dotComServer);
  MSFClient *client = [MSFClient authenticatedClientWithUser:user token:@"bar" session:@""];
	
	services = mockProtocol(@protocol(MSFViewModelServices));
	[given([services httpClient]) willReturn:client];
	viewModel = [[MSFClozeViewModel alloc] initWithServices:services];
});

it(@"should initialize", ^{
  // then
  expect(viewModel.name).to(equal(@""));
  expect(viewModel.card).to(equal(@""));
  expect(viewModel.expired).to(beAKindOf(NSDate.class));
	expect(viewModel.services).notTo(beNil());
});

it(@"should can execute valid", ^{
  // given
  viewModel.name = @"xxx";
  viewModel.card = @"111111111111111111";
	viewModel.bankNO = @"xx";
	viewModel.bankName = @"yy";
	viewModel.bankAddress = @"zz";
 __block BOOL valid = NO;
  // when
  [viewModel.authoriseValidSignal subscribeNext:^(id x) {
    valid = [x boolValue];
  }];
  
  // then
  expect(@(valid)).to(beTruthy());
});

it(@"should execute submit", ^{
  // given
  viewModel.name = @"张三";
  viewModel.card = @"111111111111111111";
  viewModel.expired = [NSDate date];
	viewModel.bankNO = @"10000000000000000";
	viewModel.bankName = @"xx";
	viewModel.bankAddress = @"mmm";
	viewModel.bankCode = @"1000";
	viewModel.addressViewModel.provinceCode = @"1000";
	viewModel.addressViewModel.cityCode = @"1000";
  [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
    NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"authorizations" withExtension:@"json"];
    return [OHHTTPStubsResponse responseWithFileURL:fileURL statusCode:200 responseTime:0 headers: @{
       @"Content-Type": @"application/json",
       @"finance": @"token",
       @"msfinance": @"objectid",
       }];
  }];
	
  __block MSFClient *client;
  [[viewModel.executeAuth.executionSignals concat] subscribeNext:^(id x) {
    client = x;
  }];
  
  BOOL success = NO;
  NSError *error;
  // when
  [[viewModel.executeAuth execute:nil] asynchronousFirstOrDefault:nil success:&success error:&error];
  
  // then
  expect(@(success)).to(beTruthy());
  expect(error).to(beNil());
  expect(client.user.objectID).to(equal(@"ds13dsaf21d"));
});

it(@"should update identifier expired date", ^{
	// when
	viewModel.expired = [NSDateFormatter msf_dateFromString:@"2015-07-01 16:30:00"];
	
	// then
	expect(viewModel.expired1).to(equal(@"2015-07-01"));
});

it(@"should not parser nil date", ^{
	// when
	viewModel.permanent = YES;
	
	// then
	expect(viewModel.expired1).to(equal(@""));
});

QuickSpecEnd
