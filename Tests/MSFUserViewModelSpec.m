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
#import "MSFAuthorizeViewModel.h"

QuickSpecBegin(MSFUserViewModelSpec)

__block MSFUserViewModel *viewModel = nil;
__block id <MSFViewModelServices> services;
__block MSFAuthorizeViewModel *authorizeViewModel;

beforeEach(^{
  MSFUser *user = mock(MSFUser.class);
  stubProperty(user, objectID, @"xx");
  stubProperty(user, server, MSFServer.dotComServer);
  MSFClient *client = [MSFClient authenticatedClientWithUser:user token:@"xxx"];
	
	services = mockProtocol(@protocol(MSFViewModelServices));
	[given([services httpClient]) willReturn:client];
	authorizeViewModel = mock([MSFAuthorizeViewModel class]);
	
	viewModel = [[MSFUserViewModel alloc] initWithAuthorizeViewModel:authorizeViewModel services:services];
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

QuickSpecEnd
