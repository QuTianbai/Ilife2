//
//  MSFBankCardListViewModel.m
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFBankCardListViewModel.h"
#import "MSFClient+MSFBankCardList.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFBankCardListViewModel ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MSFBankCardListViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)servers {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = servers;
	_executeSetMaster = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeSetMasterSignal];
	}];
	_executeUnbind = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeUnbindSignal];
	}];
//	_executeBankList = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//		return [self executeBankListSignal];
//	}];
	
	return self;
}

- (MSFBankCardInfoViewModel *)getBankCardInfoViewModel:(NSInteger)integer {
	return self.dataArray[integer];
}

- (RACSignal *)executeBankListSignal {
	return [[self.services.httpClient fetchBankCardList] collect];
}

- (RACSignal *)executeSetMasterSignal {
	return [self.services.httpClient setMasterBankCard:self.bankCardID AndTradePwd:self.pwd];
}

- (RACSignal *)executeUnbindSignal {
	return [self.services.httpClient unBindBankCard:self.bankCardID AndTradePwd:self.pwd];
}

@end
