//
//  MSFCheckHasTradePassword.m
//  Finance
//
//  Created by xbm on 15/9/30.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCheckTradePasswordViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+CheckTradePassword.h"

@interface MSFCheckTradePasswordViewModel ()

@property (nonatomic, strong) id<MSFViewModelServices>services;

@end

@implementation MSFCheckTradePasswordViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	
	_executeChenkTradePassword = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self checkTradePassword];
	}];
	
	return self;
}

- (RACSignal *)checkTradePassword {
	return [self.services.httpClient fetchCheckTradePassword];
}

@end
