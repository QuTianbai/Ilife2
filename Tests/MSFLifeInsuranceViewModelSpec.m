//
// MSFLifeInsuranceViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLifeInsuranceViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "MSFClient.h"
#import "MSFClient+LifeInsurance.h"
#import "MSFLoanType.h"

QuickSpecBegin(MSFLifeInsuranceViewModelSpec)

__block MSFLifeInsuranceViewModel *viewModel;
__block id <MSFViewModelServices> services;
__block MSFLoanType *loanType;

beforeEach(^{
	services = mockProtocol(@protocol(MSFViewModelServices));
	loanType = mock([MSFLoanType class]);
	stubProperty(loanType, typeID, @"");
	
	viewModel = [[MSFLifeInsuranceViewModel alloc] initWithServices:services loanType:loanType];
	expect(viewModel).notTo(beNil());
});

it(@"should fetch HTML content", ^{
	// given
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://foo"]];
	MSFClient *client = mock([MSFClient class]);
	[given([client fetchLifeInsuranceAgreementWithLoanType:loanType]) willReturn:[RACSignal return:request]];
	[given([services httpClient]) willReturn:client];
	
	[OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
		if ([request isEqual:request]) return [OHHTTPStubsResponse responseWithData:[@"foo" dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 responseTime:0 headers:nil];
		return nil;
	}];
	
	// when
	NSString *html = [viewModel.lifeInsuranceHTMLSignal asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// then
	expect(html).to(equal(@"foo"));
});

QuickSpecEnd
