//
// MSFAuthorizeViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAuthorizeViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient.h"
#import "MSFServer.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "MSFResponse.h"
#import "MSFUser.h"
#import "MSFViewModelServicesImpl.h"
#import "NSString+Matches.h"

QuickSpecBegin(MSFAuthorizeViewModelSpec)

__block MSFAuthorizeViewModel *viewModel;
__block id <MSFViewModelServices> services;

__block NSError *error;
__block BOOL success;

beforeEach(^{
	services = [[MSFViewModelServicesImpl alloc] init];
  viewModel = [[MSFAuthorizeViewModel alloc] initWithServices:services];
  error = nil;
  success = NO;
});

it(@"should initialize", ^{
  // then
  expect(viewModel).notTo(beNil());
  expect(viewModel.services).to(equal(services));
});

it(@"should change login type", ^{
	// when
	viewModel.loginType = MSFLoginSignUp;
	
	// then
	expect(@(viewModel.loginType)).to(equal(@(MSFLoginSignUp)));
});

it(@"should has username", ^{
  // then
  expect(viewModel.username).to(equal(@""));
  expect(viewModel.password).to(equal(@""));
  expect(viewModel.captcha).to(equal(@""));
	expect(viewModel.counter).to(equal(@"获取验证码"));
});

it(@"should can signin", ^{
  // given
  viewModel.username = @"18696995689";
  viewModel.password = @"123456qw";
  viewModel.captcha = @"666666";
  
  // when
  RACSignal *signInValidSignal = [viewModel signInValidSignal];
  __block BOOL valid = NO;
  [signInValidSignal subscribeNext:^(id x) {
    valid = [x boolValue];
  }];
  
  // then
  expect(@(valid)).to(beTruthy());
});

it(@"should can't signin", ^{
  // given
  viewModel.username = @"18696995689";
  viewModel.password = @"12345w";
  
  // when
  RACSignal *signInValidSignal = [viewModel signInValidSignal];
  __block BOOL valid = NO;
  [signInValidSignal subscribeNext:^(id x) {
    valid = [x boolValue];
  }];
  
  // then
  expect(@(valid)).to(beTruthy());
});

it(@"should can signup", ^{
  // given
  viewModel.username = @"18696995689";
  viewModel.password = @"123456qw";
  viewModel.captcha = @"123456";
  viewModel.agreeOnLicense = YES;
  
  // when
  __block BOOL valid;
  [[viewModel signUpValidSignal] subscribeNext:^(id x) {
     valid = [x boolValue];
   }];
  
  // then
  expect(@(valid)).to(beTruthy());
});

it(@"should signup valid", ^{
  // given
  viewModel.username = @"18696995689";
  viewModel.password = @"123456";
  viewModel.captcha = @"12345";
  
  // when
  __block BOOL valid;
  [[viewModel signUpValidSignal] subscribeNext:^(id x) {
     valid = [x boolValue];
   }];
  
  // then
  expect(@(valid)).to(beTruthy());
});

it(@"should signup invalid", ^{
	// given
	__block BOOL valid = YES;
	
	// when
	[viewModel.signUpValidSignal subscribeNext:^(id x) {
		valid = [x boolValue];
	}];
	
	// then
	expect(@(valid)).notTo(beFalsy());
});

it(@"should sign up server", ^{
  // given
  viewModel.username = @"18696995689";
  viewModel.password = @"123456qw";
  viewModel.captcha = @"1234";
	viewModel.name = @"张三";
	viewModel.card = @"500111100000111001";
	viewModel.expired = [NSDate distantFuture];
  viewModel.agreeOnLicense = YES;
  
  [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
    NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"authorizations" withExtension:@"json"];
    return [OHHTTPStubsResponse responseWithFileURL:fileURL statusCode:200 responseTime:0 headers: @{
       @"Content-Type": @"application/json",
       @"token": @"token",
       }];
  }];
  
  // when
  __block MSFClient *client;
  [[viewModel.executeSignUp.executionSignals concat] subscribeNext:^(id x) {
    client = x;
  }];
  [[viewModel.executeSignUp execute:nil] asynchronousFirstOrDefault:nil success:&success error:&error];
  
  // then
  expect(error).to(beNil());
  expect(client).to(beAKindOf(MSFClient.class));
  expect(@(client.authenticated)).to(beTruthy());
  expect(client.token).to(equal(@"token"));
});

it(@"should request captcha code valid", ^{
  // given
  viewModel.username = @"18696995689";
  
  // when
  __block BOOL valid;
  [[viewModel captchaRequestValidSignal] subscribeNext:^(id x) {
    valid = [x boolValue];
  }];
  
  // then
  expect(@(valid)).to(beTruthy());
});

it(@"should signin server", ^{
  // given
  viewModel.username = @"18696995689";
  viewModel.password = @"123456qw";
  viewModel.captcha = @"111111";
  
  [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
    NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"authorizations" withExtension:@"json"];
    return [OHHTTPStubsResponse responseWithFileURL:fileURL statusCode:200 responseTime:0 headers: @{
       @"Content-Type": @"application/json",
       @"token": @"token",
       }];
  }];
  
  // when
  __block MSFClient *client;
  [[viewModel.executeSignIn.executionSignals concat] subscribeNext:^(id x) {
    client = x;
  }];
  
  [[viewModel.executeSignIn execute:nil] asynchronousFirstOrDefault:nil success:&success error:&error];
  
  // then
  expect(error).to(beNil());
  expect(client).to(beAKindOf(MSFClient.class));
  expect(@(client.authenticated)).to(beTruthy());
  expect(client.token).to(equal(@"token"));
});

it(@"should change agreee license status", ^{
  // given
  __block BOOL agree = NO;
  
  // when
  [[viewModel.executeAgreeOnLicense.executionSignals concat] subscribeNext:^(id x) {
    agree = [x boolValue];
  }];
  [[viewModel.executeAgreeOnLicense execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
  
  // then
  expect(@(viewModel.agreeOnLicense)).to(beTruthy());
  expect(@(agree)).to(beTruthy());
});

it(@"should send request to get register captcha", ^{
  // given
  viewModel.username = @"18696995689";
  [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"message" withExtension:@"json"];
    return [OHHTTPStubsResponse responseWithFileURL:URL statusCode:200 responseTime:0 headers:@{@"Content-Type": @"application/json"}];
  }];
  __block MSFResponse *resposne;
  __block BOOL valid = NO;
  
  [viewModel.captchaRequestValidSignal subscribeNext:^(id x) {
    valid = [x boolValue];
  }];
  
  expect(@(valid)).to(beTruthy());
  
  // when
  [[viewModel.executeCaptcha.executionSignals concat] subscribeNext:^(id x) {
    resposne = x;
  }];
  
  [[viewModel.executeCaptcha execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
  
  // then
  expect(resposne).notTo(beNil());
  expect(resposne.parsedResult[@"message"]).to(equal(@"send success"));
});

it(@"should send request for find password captcha", ^{
  // given
  viewModel.username = @"18696995689";
  [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"message" withExtension:@"json"];
    return [OHHTTPStubsResponse responseWithFileURL:URL statusCode:200 responseTime:0 headers:@{@"Content-Type": @"application/json"}];
  }];
  __block MSFResponse *resposne;
  __block BOOL valid = NO;
  [viewModel.captchaRequestValidSignal subscribeNext:^(id x) {
    valid = [x boolValue];
  }];
  expect(@(valid)).to(beTruthy());
  
  // when
  [[viewModel.executeFindPasswordCaptcha.executionSignals concat] subscribeNext:^(id x) {
    resposne = x;
  }];
  [[viewModel.executeFindPasswordCaptcha execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
  
  // then
  expect(resposne).notTo(beNil());
  expect(resposne.parsedResult[@"message"]).to(equal(@"send success"));
});

it(@"should execute find password", ^{
  // given
  viewModel.username = @"18696995689";
  viewModel.captcha = @"1234";
  viewModel.password = @"123456qw";
	viewModel.name = @"张三";
	viewModel.card = @"500111111111111111";
  [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"message" withExtension:@"json"];
    return [OHHTTPStubsResponse responseWithFileURL:URL statusCode:200 responseTime:0 headers:@{@"Content-Type": @"application/json"}];
  }];
  __block MSFResponse *response;
  __block BOOL valid = NO;
  [viewModel.findPasswordValidSignal subscribeNext:^(id x) {
    valid = [x boolValue];
  }];
  expect(@(valid)).to(beTruthy());
  
  // when
  [[viewModel.executeFindPassword.executionSignals concat] subscribeNext:^(id x) {
    response = x;
  }];
  [[viewModel.executeFindPassword execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
  
  // then
  expect(response.parsedResult[@"message"]).to(equal(@"send success"));
});

it(@"should accept user name", ^{
	// then
	expect(@([@"张·三" isChineseName])).to(beTruthy());
});

it(@"should not accept user name", ^{
	// then
	expect(@([@"张三." isChineseName])).to(beFalsy());
});

QuickSpecEnd
