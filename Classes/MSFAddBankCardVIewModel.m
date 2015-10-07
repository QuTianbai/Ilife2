//
//  MSFAddBankCardVIewModel.m
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFAddBankCardVIewModel.h"
#import "MSFBankInfoModel.h"
#import <FMDB/FMDB.h>
#import "MSFAddressViewModel.h"
#import "MSFAddressInfo.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient.h"
#import <NSString-Hashes/NSString+Hashes.h>
#import "MSFClient+Users.h"

static NSString *const MSFAddBankCardViewModelErrorDomain = @"MSFAddBankCardViewModelErrorDomain";

@interface MSFAddBankCardVIewModel ()

@property (nonatomic, strong) FMDatabase *fmdb;

@property (nonatomic, strong, readwrite) MSFAddressViewModel *addressViewModel;

@property (nonatomic, copy) NSString *oldBankNo;

@end

@implementation MSFAddBankCardVIewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services andIsFirstBankCard:(BOOL)isFirstBankCard {
	self = [super init];
	
	if (!self) {
		return nil;
	}
	[self initialize];
	_bankNO = @"";
	_transPassword = @"";
	_bankBranchCityCode = @"";
	_bankBranchProvinceCode = @"";
	_oldBankNo = @"";
	_services = services;
	_bankAddress = @"";
	_isFirstBankCard = isFirstBankCard;
	
	_addressViewModel = [[MSFAddressViewModel alloc] initWithServices:services];
	_executeSelected = self.addressViewModel.selectCommand;
	@weakify(self)
	_executeAddBankCard = [[RACCommand alloc] initWithEnabled:[self submitValidSignal] signalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executeAuthSignal];
	}];
	
	RAC(self, bankAddress) = [[RACObserve(self.addressViewModel, address) ignore:nil] map:^id(id value) {
		if (self.addressViewModel.provinceName == nil || self.addressViewModel.cityName == nil) {
			return @"";
		}
		return [NSString stringWithFormat:@"%@  %@", self.addressViewModel.provinceName,self.addressViewModel.cityName];
	}];
	RAC(self, bankBranchCityCode) = [RACObserve(self.addressViewModel, cityCode) ignore:nil];
	RAC(self, bankBranchProvinceCode) = [RACObserve(self.addressViewModel, provinceCode) ignore:nil];
	
	RAC(self, bankInfo) = [RACObserve(self, bankNO) map:^id(NSString *bankNO) {
		if (bankNO.length >= 3) {
			return [self selectBankInfo];
		}
		return nil;
	}];
	RAC(self, maxSize) = RACObserve(self, bankInfo.maxSize);
	RAC(self, bankName) = RACObserve(self, bankInfo.name);
	RAC(self, bankCode) = RACObserve(self, bankInfo.code);
	RAC(self, bankType) = [RACObserve(self, bankInfo.type) map:^id(NSString *type) {
		switch (type.intValue) {
			case 1:
				return @"借记卡";
				break;
			case 2:
				return @"贷记卡";
				break;
			case 3:
				return @"准贷记卡";
				break;
			case 4:
				return @"预付费卡";
				break;
				
			default:
				break;
		}
		
		return @"";
	}];
	
	_executeReSetTradePwd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeResetTrade];
	}];

	
	return self;
}

- (void)initialize {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"db"];
	_fmdb = [FMDatabase databaseWithPath:path];
}

- (MSFBankInfoModel *)selectBankInfo {
	NSString *tempBankNo = [self.bankNO stringByReplacingOccurrencesOfString:@" " withString:@""];
	if (![self.oldBankNo isEqualToString:@""]) {
		for (int i = 0; i < tempBankNo.length; i ++) {
			NSString *tmp = [tempBankNo substringToIndex:i];
			if ([tmp isEqualToString:self.oldBankNo]) {
				return self.bankInfo;
			}
		}
	}
	
	if (![self.fmdb open]) {
		return nil;
	}
	
	NSError *error;
	NSString *sqlStr = [NSString stringWithFormat:@"select * from basic_bank_bin where bank_bin='%@'", tempBankNo];
	
	FMResultSet *rs = [self.fmdb executeQuery:sqlStr];
	MSFBankInfoModel *bankInfo = nil;
	NSMutableArray *itemArray = [[NSMutableArray alloc] init];
	while ([rs next]) {
		MSFBankInfoModel *tmpBankInfo = [MTLFMDBAdapter modelOfClass:MSFBankInfoModel.class fromFMResultSet:rs error:&error];
		[itemArray addObject:tmpBankInfo];
	}
	if (itemArray.count == 1) {
		self.oldBankNo = tempBankNo;
		bankInfo = [itemArray firstObject];
	} else {
		bankInfo = nil;
	}
	[self.fmdb close];
	return bankInfo;
}

- (RACSignal *)submitValidSignal {
	
	return [RACObserve(self, bankInfo.support) map:^id(NSString *support) {
		int re = 0;
		switch (support.intValue) {
			case 0:
			case 3:
				re = 1;
				break;
			case 2:
				if (!self.isFirstBankCard) {
					re = 1;
				}
				break;
				
			default:
				break;
		}
		return [NSNumber numberWithInt:re];
		//		return @( support == nil || support.intValue == 0 || support.intValue != 1 || support.intValue != 2 || support.intValue ==3);
	}];
}

- (RACSignal *)executeAuthSignal {
	NSError *error = nil;
	
	if (self.addressViewModel.provinceCode.length == 0) {
		error = [NSError errorWithDomain:MSFAddBankCardViewModelErrorDomain code:0 userInfo:@{
																																										NSLocalizedFailureReasonErrorKey: @"请选择开户行地区",
																																										}];
		return [RACSignal error:error];
	}
	if (self.bankNO.length == 0 || [self.bankNO stringByReplacingOccurrencesOfString:@" " withString:@""].length < 14 || [self.bankNO stringByReplacingOccurrencesOfString:@" " withString:@""].length != self.maxSize.integerValue ) {
		NSString *str = @"请填写正确的银行卡号";
		if (self.bankNO.length == self.maxSize.integerValue) {
			str = @"你的银行卡号长度有误，请修改后再试";
		}
		error = [NSError errorWithDomain:MSFAddBankCardViewModelErrorDomain code:0 userInfo:@{
NSLocalizedFailureReasonErrorKey: str,
																																										}];
		return [RACSignal error:error];
	}
	return [self.services.httpClient addBankCardWithTransPassword:self.transPassword AndBankCardNo:[self.bankNO stringByReplacingOccurrencesOfString:@" " withString:@""] AndbankBranchProvinceCode:self.bankBranchProvinceCode AndbankBranchCityCode:self.bankBranchCityCode];
}

- (RACSignal *)executeResetTrade {
	return [self.services.httpClient resetTradepwdWithBankCardNo:[self.bankNO stringByReplacingOccurrencesOfString:@" " withString:@""] AndprovinceCode:self.bankBranchProvinceCode AndcityCode:self.bankBranchCityCode AndsmsCode:self.smsCode AndnewTransPassword:self.TradePassword.sha256];
}

@end
