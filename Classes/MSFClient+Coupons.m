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
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"coupon/couponsList" parameters:@{
		@"status": status,
	}];
	return [[self enqueueRequest:request resultClass:MSFCoupon.class] msf_parsedResults];
}

- (RACSignal *)addCouponWithCode:(NSString *)code {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"coupon/couponBind" parameters:@{
		@"code": code,
	}];
	return [[self enqueueRequest:request resultClass:MSFCoupon.class] msf_parsedResults];
}

@end
