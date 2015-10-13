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

@interface MSFLifeInsuranceViewModel ()

@property (nonatomic, weak) id<MSFViewModelServices> services;

@end

@implementation MSFLifeInsuranceViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	
	return self;
}

- (RACSignal *)lifeInsuranceHTMLSignal {
	return [[self.services.httpClient fetchLifeInsuranceAgreement]
		flattenMap:^RACStream *(id value) {
			return [[NSURLConnection rac_sendAsynchronousRequest:value]
				reduceEach:^id(NSURLResponse *responce, NSData *data){
					return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				}];
		}];
}

@end
