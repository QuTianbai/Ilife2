//
// MSFAgreementViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAgreementViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAgreement.h"
#import "MSFServer.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

QuickSpecBegin(MSFAgreementViewModelSpec)

__block MSFAgreementViewModel *viewModel;

beforeEach(^{
  MSFServer *server = [MSFServer serverWithBaseURL:[NSURL URLWithString:@"http://192.168.2.51:8088"]];
  MSFAgreement *agreement = [[MSFAgreement alloc] initWithServer:server];
  viewModel = [[MSFAgreementViewModel alloc] initWithModel:agreement];
});

it(@"should initialize", ^{
  // then
  expect(viewModel).notTo(beNil());
});

it(@"should has register agreement html url", ^{
  // given
  [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
    NSData *data = [@"xxx" dataUsingEncoding:NSUTF8StringEncoding];
    return [OHHTTPStubsResponse responseWithData:data statusCode:200 responseTime:0 headers:@{}];
  }];
  
  // then
  NSString *HTML = [viewModel.registerAgreementSignal asynchronousFirstOrDefault:nil success:nil error:nil];
  expect(HTML).to(equal(@"xxx"));
});

QuickSpecEnd
