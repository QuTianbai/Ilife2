//
//  MSFRepaymentViewModel.m
//  Finance
//
//  Created by 赵勇 on 8/14/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFRepaymentPlanViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFClient+RepaymentSchedules.h"

@interface MSFRepaymentPlanViewModel ()

@end

@implementation MSFRepaymentPlanViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	
	return self;
}

- (RACSignal *)fetchRepaymentSchedulesSignal {
	return [self.services.httpClient fetchRepaymentSchedules];
}

- (RACSignal *)fetchCircleRepaymentSchrdulesSignal {
	return nil;
//	return [self.services.httpClient fetchCircleRepaymentSchedules];
}

@end
