//
//  MSFClient+MSFLifeInsurance.m
//  Finance
//
//  Created by xbm on 15/10/13.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFLifeInsurance.h"
#import "MSFUtils.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MSFClient (MSFLifeInsurance)

- (RACSignal *)fetchLifeInsuranceAgreement {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/life" parameters:@{@"productCode": MSFUtils.productCode, @"templateType": @"LIFE_INSURANCE_PROTOCOL"}];
		[subscriber sendNext:request];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end