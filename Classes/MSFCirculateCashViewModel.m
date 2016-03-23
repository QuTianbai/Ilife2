//
//  MSFCirculateCashViewModel.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCirculateCashViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+CirculateCash.h"
#import "MSFCirculateCashModel.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFClient+BankCardList.h"

@implementation MSFCirculateCashViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_infoModel = [[MSFCirculateCashModel alloc] init];
	
	RAC(self, totalLimit) = RACObserve(self, infoModel.totalLimit);
	RAC(self, usedLimit) = RACObserve(self, infoModel.usedLimit);
	RAC(self, usableLimit) = RACObserve(self, infoModel.usableLimit);
	RAC(self, contractExpireDate) = [RACObserve(self,infoModel.contractExpireDate) map:^id(NSString *value) {
		NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
		[inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
		[inputFormatter setDateFormat:@"yyyyMMdd"];
		inputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
		NSDate *inputDate = [inputFormatter dateFromString:value?:@""];
		NSString *str = @"";
		if (inputDate != nil) {
			str = [NSDateFormatter msf_stringFromDate:inputDate];
		}
		return str;
	}];
	RAC(self, latestDueMoney) = [RACObserve(self, infoModel.latestDueMoney) map:^id(id value) {
		if (value == nil) {
			return @"0";
		}
		return value;
	}];
	RAC(self, latestDueDate) = [RACObserve(self, infoModel.latestDueDate) map:^id(NSString *value) {
		if (value == nil) {
			return @"0000-00-00";
		}
		NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
		[inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
		inputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
		[inputFormatter setDateFormat:@"yyyyMMdd"];
		NSDate *inputDate = [inputFormatter dateFromString:value];
		NSString *str = @"";
		if (inputDate != nil) {
			str = [NSDateFormatter msf_stringFromDate:inputDate];
		}
		return str;
	}];
	RAC(self, totalOverdueMoney) = RACObserve(self, infoModel.totalOverdueMoney);
	RAC(self, contractNo) = RACObserve(self, infoModel.contractNo);
	RAC(self, overdueMoney) = RACObserve(self, infoModel.overdueMoney);
	RAC(self, contractStatus) = RACObserve(self, infoModel.contractStatus);

	@weakify(self)
	_executeRefrshCashHomeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self.services.httpClient fetchCirculateCash:@"2"];
	}];
	[_executeRefrshCashHomeCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
		@strongify(self)
		[self.infoModel mergeValuesForKeysFromModel:x];
	} error:^(NSError *error) {
		NSLog(@"%@", error.localizedDescription);
	}];
	
	return self;
}

- (RACSignal *)fetchBankCardListSignal {
	return [self.services.httpClient fetchBankCardList];
}

@end
