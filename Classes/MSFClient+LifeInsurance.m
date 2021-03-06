//
//  MSFClient+MSFLifeInsurance.m
//  Finance
//
//  Created by xbm on 15/10/13.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+LifeInsurance.h"
#import "MSFUser.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFLoanType.h"

@implementation MSFClient (LifeInsurance)

- (RACSignal *)fetchLifeInsuranceAgreementWithProductType:(NSString *)product {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/life" parameters:@{
			@"productCode": product,
			@"templateType": @"LIFE_INSURANCE_PROTOCOL"
		}];
		[subscriber sendNext:request];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)fetchLifeInsuranceAgreementWithLoanType:(MSFLoanType *)loanType {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/life" parameters:@{
			@"productCode": loanType.typeID,
			@"templateType": @"LIFE_INSURANCE_PROTOCOL"
		}];
		[subscriber sendNext:request];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end