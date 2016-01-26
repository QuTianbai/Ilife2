//
// MSFCouponViewModel.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCouponViewModel.h"
#import "MSFCoupon.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NSDateFormatter+MSFFormattingAdditions.h"

@interface MSFCouponViewModel ()

@property (nonatomic, strong) MSFCoupon *model;

@end

@implementation MSFCouponViewModel

- (instancetype)initWithModel:(id)model {
  self = [super init];
  if (!self) {
    return nil;
  }
	_model = model;
	
	RAC(self, title) = RACObserve(self, model.ticketName);
	RAC(self, subtitle) = RACObserve(self, model.receiveChannel);
	RAC(self, value) = RACObserve(self, model.value);
	RAC(self, intro) = RACObserve(self, model.type);
	RAC(self, timeRange) = [RACObserve(self, model) map:^id(MSFCoupon *value) {
		return [NSString stringWithFormat:@"%@ 至 %@",
			[NSDateFormatter msf_stringFromDate:value.effectDateBegin], [NSDateFormatter msf_stringFromDate:value.effectDateEnd]];
	}];
	RAC(self, days) = [RACObserve(self, model) map:^id(MSFCoupon *value) {
		double diff = [value.effectDateEnd timeIntervalSince1970] - [value.effectDateBegin timeIntervalSince1970];
		int d = (int)(diff / (24 * 60 * 60));
		return @(d);
	}];
	RAC(self, timeLeft) = [RACObserve(self, days) map:^id(NSNumber *value) {
		return [[value stringValue] stringByAppendingFormat:@"天后到期"];
	}];
	
	RAC(self, isWarning) = [RACObserve(self, days) map:^id(id value) {
		return @([value integerValue] <= 7);
	}];
	
	RAC(self, colorHex) = [RACObserve(self, days) map:^id(id value) {
		if ([value integerValue] < 0) return @(0xc1c1c1);
		return [value integerValue] < 4 ? @(0xff6c6c) : @(0xffc600);
	}];
	
	RAC(self, imageName) = [RACObserve(self, model.status) map:^id(id value) {
		return [value isEqualToString:@"B"] ? @"cell-icon-unused.png" : @"cell-icon-used.png";
	}];
	
  return self;
}

@end
