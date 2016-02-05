//
// MSFPaymentViewModelSpec.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFPaymentViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFOrderDetail.h"
#import "MSFClient+BankCardList.h"
#import "MSFBankCardListModel.h"
#import "MSFPaymentToken.h"
#import "MSFClient+Users.h"

QuickSpecBegin(MSFPaymentViewModelSpec)

__block MSFPaymentViewModel *sut;
__block MSFOrderDetail *model;
__block id<MSFViewModelServices> services;
__block MSFClient *client;

beforeEach(^{
	model = mock([MSFOrderDetail class]);
	stubProperty(model, downPmt, @"100");
	
	client = mock([MSFClient class]);
	services = mockProtocol(@protocol(MSFViewModelServices));
	[given([services httpClient]) willReturn:client];
	
	sut = [[MSFPaymentViewModel alloc] initWithModel:model services:services];
	expect(sut).notTo(beNil());
});

it(@"should initialize", ^{
  // then
	expect(sut.model).notTo(beNil());
	expect(sut.services).notTo(beNil());
	expect(sut.captcha).to(equal(@""));
	expect(sut.title).to(equal(@"首付支付"));
	expect(sut.summary).to(equal(@"请支付首付金额¥100"));
	expect(sut.amounts).to(equal(@"100"));
});

it(@"should bank information", ^{
	// given
	MSFBankCardListModel *mockModel = mock([MSFBankCardListModel class]);
	stubProperty(mockModel, bankCode, @"");
	stubProperty(mockModel, bankName, @"foo");
	stubProperty(mockModel, bankCardNo, @"1234");
	stubProperty(mockModel, master, @YES);
	[given([client fetchBankCardList]) willReturn:[RACSignal return:mockModel]];
	
	// when
	sut.active = YES;
	
	// then
	expect(sut.bankIco).to(equal(@"bankdefult"));
	expect(sut.bankName).to(equal(@"foo"));
	expect(sut.bankNo).to(equal(@"1234"));
});


it(@"should have support banks description", ^{
	// given
	[given([client fetchSupportBankInfo]) willReturn:[RACSignal return:@"foo"]];
	
	// when
	sut.active = YES;
	
	// then
	expect(sut.supports).to(equal(@"foo"));
});

it(@"should request for captcha", ^{
	// given
	MSFPaymentToken *mockModel = mock([MSFPaymentToken class]);
	stubProperty(mockModel, smsSeqNo, @"foo");
	[given([client sendSmsCodeForTrans]) willReturn:[RACSignal return:mockModel]];
	
	// when
	BOOL success;
	NSError *error;
	[[sut.executeCaptchaCommand execute:nil] asynchronousFirstOrDefault:nil success:&success error:&error];
	
	// then
	expect(error).to(beNil());
	expect(@(success)).to(beTruthy());
	expect(sut.uniqueTransactionID).to(equal(@"foo"));
});

it(@"should has transactions password", ^{
	// when
	sut.transactionPassword = @"123456";
	
	// then
	expect(sut.transactionPassword).to(equal(@"123456"));
});

QuickSpecEnd
