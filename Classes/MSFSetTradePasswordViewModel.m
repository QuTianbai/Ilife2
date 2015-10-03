//
//  MSFSetTradePasswordViewModel.m
//  Finance
//
//  Created by xbm on 15/10/3.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSetTradePasswordViewModel.h"
#import "MSFViewModelServices.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+Captcha.h"
#import "MSFClient.h"
#import "MSFUtils.h"

static const int kCounterLength = 60;

@interface MSFSetTradePasswordViewModel ()

@property (nonatomic, assign) id<MSFViewModelServices>services;

@end

@implementation MSFSetTradePasswordViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_counting = NO;
	_services = services;
	
	_captchaNomalImage = [[UIImage imageNamed:@"bg-send-captcha"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 5) resizingMode:UIImageResizingModeStretch];
	_captchaHighlightedImage = [[UIImage imageNamed:@"bg-send-captcha-highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 5) resizingMode:UIImageResizingModeStretch];
	@weakify(self)
	_executeCaptcha = [[RACCommand alloc] initWithEnabled:self.captchaRequestValidSignal signalBlock:^RACSignal *(id input) {
		return [[self executeCaptchaSignal]
						doNext:^(id x) {
							@strongify(self)
							self.counting = YES;
							RACSignal *repetitiveEventSignal = [[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength];
							__block int repetCount = kCounterLength;
							[repetitiveEventSignal subscribeNext:^(id x) {
								self.counter = [@(--repetCount) stringValue];
							} completed:^{
								self.counter = @"获取验证码";
								self.counting = NO;
							}];
						}];
	}];

	return self;
}

- (RACSignal *)executeCaptchaSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:self.services.server];
	return [client fetchSignUpCaptchaWithPhone:MSFUtils.phone];
}

- (RACSignal *)captchaRequestValidSignal {
	return [RACSignal
					combineLatest:@[
													RACObserve(self, counting)
													]
					reduce:^id( NSNumber *counting){
						return @(!counting.boolValue);
					}];
}


@end
