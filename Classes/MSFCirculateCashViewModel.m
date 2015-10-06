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

@interface MSFCirculateCashViewModel ()

@property (nonatomic, strong) MSFCirculateCashModel *infoModel;

@end

@implementation MSFCirculateCashViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_totalLimit = @"";
	_usedLimit = @"";
	_usableLimit = @"";
	_overdueMoney = @"";
	_contractExpireDate = @"";
	_latestDueMoney = @"";
	_latestDueDate = @"";
	_totalOverdueMoney = @"";
	_contractNo = @"";
	
	_infoModel = [[MSFCirculateCashModel alloc] init];
	
	RAC(self, totalLimit) = [RACObserve(self, infoModel.totalLimit) map:^id(id value) {
		return value;
	}];
	RAC(self, usedLimit) = [RACObserve(self, infoModel.usedLimit) map:^id(id value) {
		return value;
	}];
	RAC(self, usableLimit) = [RACObserve(self, infoModel.usableLimit) map:^id(id value) {
		return value;
	}];
	
	RAC(self, contractExpireDate) = RACObserve(self,infoModel.contractExpireDate);
	RAC(self, latestDueMoney) = RACObserve(self, infoModel.latestDueMoney);
	RAC(self, latestDueDate) = RACObserve(self, infoModel.latestDueDate);
	RAC(self, totalOverdueMoney) = RACObserve(self, infoModel.totalOverdueMoney);
	RAC(self, contractNo) = RACObserve(self, infoModel.contractNo);
	RAC(self, overdueMoney) = [RACObserve(self, infoModel.overdueMoney) map:^id(id value) {
		return [NSString stringWithFormat:@"已逾期：￥%@", value];
	}];

	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[self.services.httpClient fetchCirculateCash] subscribeNext:^(MSFCirculateCashModel *x) {
			//self.circulateModel = x;
			self.infoModel = x;
		} error:^(NSError *error) {
			NSLog(@"");
		}];
	}];
	
	return self;
}

- (RACSignal *)executeCirculate {
	return [self.services.httpClient fetchCirculateCash];
}

@end
