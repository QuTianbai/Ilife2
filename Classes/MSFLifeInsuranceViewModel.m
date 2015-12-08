//
//  MSFLifeInsuranceViewModel.m
//  Finance
//
//  Created by xbm on 15/10/13.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFLifeInsuranceViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+MSFLifeInsurance.h"
#import "MSFLoanType.h"

@interface MSFLifeInsuranceViewModel ()

@property (nonatomic, weak) id<MSFViewModelServices> services;
@property (nonatomic, strong) MSFLoanType *loanType;

@end

@implementation MSFLifeInsuranceViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services ProductID:(NSString *)productID {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_loanType = [[MSFLoanType alloc] initWithTypeID:productID];
	
	return self;
}

- (instancetype)initWithServices:(id<MSFViewModelServices>)services loanType:(MSFLoanType *)loanType {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_loanType = loanType;
	
	return self;
}

- (RACSignal *)lifeInsuranceHTMLSignal {
	return [[self.services.httpClient fetchLifeInsuranceAgreementWithLoanType:self.loanType]
		flattenMap:^RACStream *(id value) {
			return [[NSURLConnection rac_sendAsynchronousRequest:value]
				reduceEach:^id(NSURLResponse *responce, NSData *data){
					return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				}];
		}];
}

@end
