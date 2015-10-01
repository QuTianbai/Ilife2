//
//  MSFCirculateCashViewModel.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCirculateCashViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+MSFCirculateCash.h"
#import "MSFCirculateCashModel.h"
#import "MSFCirculateCashInfoModel.h"

@interface MSFCirculateCashViewModel ()

@property (nonatomic,assign)id<MSFViewModelServices>services;

@property (nonatomic, strong)MSFCirculateCashModel *circulateModel;

@end

@implementation MSFCirculateCashViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services =services;
	_totalLimit = @"";
	_usedLimit = @"";
	_usableLimit = @"";
	_overdueMoney = @"";
	_contractExpireDate = @"";
	_latestDueMoney = @"";
	_latestDueDate = @"";
	_totalOverdueMoney = @"";
	_contractNo = @"";
	
	RAC(self, totalLimit) = RACObserve(self.circulateModel.mydata, totalLimit);
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[self.services.httpClient fetchCirculateCash] subscribeNext:^(id x) {
			self.circulateModel = x;
		}];
	}];
	
	return self;
}

- (RACSignal *)executeCirculate {
	return [self.services.httpClient fetchCirculateCash];
}

@end
