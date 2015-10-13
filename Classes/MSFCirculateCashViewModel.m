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
#import "NSDateFormatter+MSFFormattingAdditions.h"

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
	
	RAC(self, contractExpireDate) = [RACObserve(self,infoModel.contractExpireDate) map:^id(NSString *value) {
		NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
		[inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
		[inputFormatter setDateFormat:@"yyyyMMDD"];
		NSDate *inputDate = [inputFormatter dateFromString:value];
		NSString *str = @"";
		if (inputDate != nil) {
			str = [NSDateFormatter msf_stringFromDate:inputDate];
		}
		return str;
	}];
	RAC(self, latestDueMoney) = RACObserve(self, infoModel.latestDueMoney);
	RAC(self, latestDueDate) = [RACObserve(self, infoModel.latestDueDate) map:^id(NSString *value) {
		NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
		[inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
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

	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[self.services.httpClient fetchCirculateCash] subscribeNext:^(MSFCirculateCashModel *model) {
			self.infoModel = model;
			
//			if (([model.type isEqualToString:@"APPLY"] && [model.applyStatus isEqualToString:@"A"]) || (![model.type isEqualToString:@"APPLY"] && [model.contractStatus isEqualToString:@"A"])) {
//				[[NSNotificationCenter defaultCenter] postNotificationName:MSFCONFIRMCONTACTNOTIFACATION object:nil];
//			} 
			
//			if ([model.contractStatus isEqualToString:@"A"]) {
//				self.model = model;
//				[[NSNotificationCenter defaultCenter] postNotificationName:MSFCONFIRMCONTACTNOTIFACATION object:nil];
			
		} error:^(NSError *error) {
			NSLog(@"%@", error.localizedDescription);
		}];
	}];
	
	_executeCirculateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			[[self.services.httpClient fetchCirculateCash] subscribeNext:^(MSFCirculateCashModel *x) {
				self.infoModel = x;
			} error:^(NSError *error) {
				NSLog(@"%@", error.localizedDescription);
			}];
			return nil;
		}];
	}];
	
	return self;
}

@end
