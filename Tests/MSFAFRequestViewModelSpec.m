//
// MSFAFRequestViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFProductViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFTestAFViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFProduct.h"
#import "MSFClient+Months.h"
#import "MSFClient.h"
#import "MSFResponse.h"
#import "MSFSelectKeyValues.h"
#import "MSFApplicationResponse.h"
#import "MSFClient+MSFApplyCash.h"

QuickSpecBegin(MSFAFRequestViewModelSpec)

__block MSFProductViewModel *viewModel;
__block MSFTestAFViewModel *afViewModel;
__block MSFClient *client;

beforeEach(^{
	client = mock([MSFClient class]);
	afViewModel = [[MSFTestAFViewModel alloc] initWithClient:client];
	expect(afViewModel.model).notTo(beNil());
	expect(afViewModel.market).notTo(beNil());
//	expect(afViewModel.client).notTo(beNil());
	
	[given([client applyInfoSubmit1:afViewModel.model]) willDo:^id(NSInvocation *invocaiton) {
		return [RACSignal empty];
	}];
	
//	viewModel = [[MSFProductViewModel alloc] initWithFormsViewModel:afViewModel];
	
});

it(@"should initialize", ^{
	// then
	expect(viewModel).notTo(beNil());
});

it(@"should change model amount", ^{
	// when
	viewModel.totalAmount = @"2000";
  
	// then
	expect(afViewModel.model.principal).to(equal(@"2000"));
});

it(@"should change model loan product", ^{
	// given
	NSDictionary *representation = @{
		@"period": @"3",
		@"productGroupCode": @"111111111111",
		@"proGroupId": @"85",
		@"productId": @"57",
		@"monthlyInterestRate": @"1",
		@"productName": @"weq",
		@"monthlyFeeRate": @"1",
		@"proGroupName": @"现金贷"
	};
	
	
	MSFProduct *product = [MTLJSONAdapter modelOfClass:MSFProduct.class fromJSONDictionary:representation error:nil];
	viewModel.totalAmount = @"2000";
	
	[given([client fetchTermPayWithProduct:product totalAmount:viewModel.totalAmount.integerValue insurance:viewModel.insurance])
		willDo:^id(NSInvocation *invocation) {
			MSFResponse *resposne = mock([MSFResponse class]);
			stubProperty(resposne, parsedResult, @{@"repayMoneyMonth": @200});
			return [RACSignal return:resposne];
		}];
	
	// when
	viewModel.product = product;
	
	// then
	expect(afViewModel.model.tenor).to(equal(@"3"));
	expect(afViewModel.model.productGroupCode).to(equal(@"111111111111"));
	expect(afViewModel.model.proGroupId).to(equal(@"85"));
	expect(afViewModel.model.productId).to(equal(@"57"));
	expect(afViewModel.model.monthlyInterestRate).to(equal(@"1"));
	expect(afViewModel.model.productName).to(equal(@"weq"));
	expect(afViewModel.model.monthlyFeeRate).to(equal(@"1"));
	expect(afViewModel.model.proGroupName).to(equal(@"现金贷"));
	
	expect(viewModel.productTerms).to(equal(product.title));
	expect(@(viewModel.termAmount)).to(equal(@200));
});

it(@"should should update model insurance", ^{
	// when
	viewModel.insurance = YES;
  
	// then
	expect(afViewModel.model.isSafePlan).to(equal(@"1"));
});

it(@"should update model usageCode", ^{
	// given
	NSDictionary *myDictionary = @{
		@"text" : @"数码产品",
		@"code" : @"PL02",
		@"typeId" : @"002"
	};
	
	// when
	viewModel.purpose = [[MSFSelectKeyValues alloc] initWithDictionary:myDictionary error:nil];
  
	// then
	expect(afViewModel.model.usageCode).to(equal(@"PL02"));
});

QuickSpecEnd
