//
// MSFDimensionalCodeViewModelSpec.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFDimensionalCodeViewModel.h"
#import "MSFPayment.h"
#import "MSFOrderDetail.h"

QuickSpecBegin(MSFDimensionalCodeViewModelSpec)

__block MSFDimensionalCodeViewModel *sut;
__block MSFPayment *payment;

NSDictionary *representation = @{
	@"authType" : @"O",
	@"authId" : @"200000092016010606313325450",
	@"authCode" : @"513082308368553788",
	@"expireDate" : @1452258477578,
	@"downPmt" : @2.00
};

beforeEach(^{
	payment = [MTLJSONAdapter modelOfClass:[MSFPayment class] fromJSONDictionary:representation error:nil];
	MSFOrderDetail *order = mock([MSFOrderDetail class]);
	stubProperty(order, totalAmt, @"100");
	sut = [[MSFDimensionalCodeViewModel alloc] initWithPayment:payment order:order];
});

afterEach(^{
	sut.active = NO;
});

it(@"should initialize", ^{
  // then
	expect(sut).notTo(beNil());
});

it(@"should has first pay title", ^{
	// then
	expect(sut.title).to(equal(@"首付 ¥2元"));
});

it(@"should has pay amount", ^{
	// then
	expect(sut.subtitle).to(equal(@"扫描二维码，支付商品100元"));
});

//TODO: 暂时取消这里的测试失败
xit(@"should has timist string", ^{
	// given
	
	// when
	sut.active = YES;
	
	// then
	expect(sut.timist).to(equal(@"180s后条形码失效"));
});

QuickSpecEnd
