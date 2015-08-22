//
// MSFProductSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFProduct.h"

QuickSpecBegin(MSFProductSpec)

__block MSFProduct *product;

beforeEach(^{
	NSDictionary *representation = @{
		@"period": @3,
		@"productGroupCode": @"000000001111",
		@"proGroupId": @18,
		@"productId": @24,
		@"monthlyInterestRate": @"1.33",
		@"productName": @"现金贷3期",
		@"monthlyFeeRate": @"0.88",
		@"proGroupName": @"马上现金贷(最新新)"
	};
	product = [MTLJSONAdapter modelOfClass:[MSFProduct class] fromJSONDictionary:representation error:nil];
});

it(@"should initialize", ^{
  // then
	expect(product).notTo(beNil());
	expect(product.productId).to(equal(@"24"));
	expect(product.period).to(equal(@"3"));
	expect(product.proGroupId).to(equal(@"18"));
	expect(product.proGroupName).to(equal(@"马上现金贷(最新新)"));
	expect(product.monthlyFeeRate).to(equal(@"0.88"));
	expect(product.monthlyInterestRate).to(equal(@"1.33"));
	expect(product.productGroupCode).to(equal(@"000000001111"));
	expect(product.productName).to(equal(@"现金贷3期"));
});

QuickSpecEnd
