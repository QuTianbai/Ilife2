//
// MSFClient+Coupons.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Coupons.h"
#import "MSFCoupon.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (Coupons)

- (RACSignal *)fetchCouponsWithStatus:(NSString *)status {
//TODO: 测试数据
NSDictionary *representation = @{
	@"id" : @"foo",
	@"ticketRuleId" : @1,
	@"ticketName" : @"bar",
	@"type" : @"A",
	@"phone" : @"1869699565",
	@"receiveTime" : @"2015-05-03T15:38:45Z",
	@"receiveChannel" : @"ios",
	@"effectDateBegin" : @"2015-05-03T15:38:45Z",
	@"effectDateEnd" : @"2015-08-03T15:38:45Z",
	@"status" : @"1"
};
return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
	MSFCoupon *coupon = [MTLJSONAdapter modelOfClass:[MSFCoupon class] fromJSONDictionary:representation error:nil];
	[subscriber sendNext:coupon];
	[subscriber sendNext:coupon];
	[subscriber sendCompleted];
	return nil;
}];
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"coupon/couponsList" parameters:@{
		@"status": status,
	}];
	return [[self enqueueRequest:request resultClass:MSFCoupon.class] msf_parsedResults];
}

- (RACSignal *)addCouponWithCode:(NSString *)code {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"coupon/couponBind" parameters:@{
		@"code": code,
	}];
	return [[self enqueueRequest:request resultClass:MSFCoupon.class] msf_parsedResults];
}

@end
