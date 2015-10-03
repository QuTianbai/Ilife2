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
#import "MSFProduct.h"
#import "MSFClient.h"
#import "MSFClient+Agreements.h"
#import "MSFApplyCashVIewModel.h"

QuickSpecBegin(MSFAgreementViewModelSpec)

__block MSFAgreementViewModel *viewModel;

beforeEach(^{
  MSFServer *server = [MSFServer dotComServer];
  MSFAgreement *agreement = [[MSFAgreement alloc] initWithServer:server];
  viewModel = [[MSFAgreementViewModel alloc] initWithModel:agreement];
});

afterEach(^{
	[OHHTTPStubs removeAllRequestHandlers];
});

it(@"should initialize", ^{
  // then
  expect(viewModel).notTo(beNil());
	expect(viewModel.agreement).notTo(beNil());
});

it(@"should has register agreement html url", ^{
  // given
  [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
		if (![request.URL isEqual:viewModel.agreement.registerURL]) return nil;
    NSData *data = [@"xxx" dataUsingEncoding:NSUTF8StringEncoding];
    return [OHHTTPStubsResponse responseWithData:data statusCode:200 responseTime:0 headers:@{}];
  }];
  
  // then
  NSString *HTML = [viewModel.registerAgreementSignal asynchronousFirstOrDefault:nil success:nil error:nil];
  expect(HTML).to(equal(@"xxx"));
});

it(@"should fetch about html", ^{
	// given
	[OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
		if (![request.URL isEqual:viewModel.agreement.aboutWeURL]) return nil;
		return [OHHTTPStubsResponse responseWithData:[@"foo" dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 responseTime:0 headers:@{}];
	}];
	
	// then
	NSString *HTML = [viewModel.aboutAgreementSignal asynchronousFirstOrDefault:nil success:nil error:nil];
	expect(HTML).to(equal(@"foo"));
});

it(@"should fetch product intro html", ^{
	// given
	[OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
		if (![request.URL isEqual:viewModel.agreement.productURL]) return nil;
		return [OHHTTPStubsResponse responseWithData:[@"intro" dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 responseTime:0 headers:@{}];
	}];
	
	// then
	NSString *HTML = [viewModel.productAgreementSignal asynchronousFirstOrDefault:nil success:nil error:nil];
	expect(HTML).to(equal(@"intro"));
});

it(@"should fetch user help html", ^{
	// given
	[OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
		if (![request.URL isEqual:viewModel.agreement.helpURL]) return nil;
		return [OHHTTPStubsResponse responseWithData:[@"help" dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 responseTime:0 headers:@{}];
	}];
	
	// then
	NSString *HTML = [viewModel.usersAgreementSignal asynchronousFirstOrDefault:nil success:nil error:nil];
	expect(HTML).to(equal(@"help"));
});

it(@"should fetch branch agreement html", ^{
	// given
	[OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
		if (![request.URL isEqual:viewModel.agreement.branchesURL]) return nil;
		return [OHHTTPStubsResponse responseWithData:[@"branch" dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 responseTime:0 headers:@{}];
	}];
	
	// then
	NSString *HTML = [viewModel.branchAgreementSignal asynchronousFirstOrDefault:nil success:nil error:nil];
	expect(HTML).to(equal(@"branch"));
});

it(@"should fetch loan agreement html with product", ^{
	// given
	NSURL *URL = [NSURL URLWithString:@"http://sample.com"];
	MSFApplyCashVIewModel *product = mock([MSFApplyCashVIewModel class]);
	
	MSFClient *client = mock([MSFClient class]);
	[given([client fetchAgreementURLWithProduct:product]) willDo:^id(NSInvocation *invocation) {
		return [RACSignal return:[NSURLRequest requestWithURL:URL]];
	}];
	id <MSFViewModelServices> services = mockProtocol(@protocol(MSFViewModelServices));
	[given([services httpClient]) willReturn:client];
	
	viewModel = [[MSFAgreementViewModel alloc] initWithServices:services];
	
	[OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
		if (![request.URL isEqual:URL]) return nil;
		return [OHHTTPStubsResponse responseWithData:[@"product" dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 responseTime:0 headers:@{}];
	}];
	
	// then
	NSString *HTML = [[viewModel loanAgreementSignalWithViewModel:product] asynchronousFirstOrDefault:nil success:nil error:nil];
	expect(HTML).to(equal(@"product"));
});

QuickSpecEnd
