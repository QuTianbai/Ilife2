//
//  MSFAddBankCardVIewModel.m
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFAddBankCardViewModel.h"
#import "MSFBankInfoModel.h"
#import <FMDB/FMDB.h>
#import "MSFAddressViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient.h"
#import <NSString-Hashes/NSString+Hashes.h>
#import "MSFClient+Users.h"
#import "NSString+Matches.h"
#import "MSFClient+BankCardList.h"

static NSString *const MSFAddBankCardViewModelErrorDomain = @"MSFAddBankCardViewModelErrorDomain";

@interface MSFAddBankCardViewModel ()

@property (nonatomic, strong) FMDatabase *fmdb;
@property (nonatomic, strong, readwrite) MSFAddressViewModel *addressViewModel;
@property (nonatomic, copy) NSString *oldBankNo;

@end

@implementation MSFAddBankCardViewModel

- (instancetype)initWithFormsViewModel:(id)formsViewModel andIsFirstBankCard:(BOOL)isFirstBankCard {
  self = [super init];
  if (!self) {
    return nil;
  }
  
  return self;
}

- (instancetype)initWithServices:(id <MSFViewModelServices>)services andIsFirstBankCard:(BOOL)isFirstBankCard {
	self = [super init];
	
	if (!self) {
		return nil;
	}
	[self initialize];
	_bankNO = @"";
	_transPassword = @"";
	_bankBranchCityCode = @"";
	_supportBanks = @"";
	_bankBranchProvinceCode = @"";
	_oldBankNo = @"";
	_services = services;
	_bankAddress = @"";
	_isFirstBankCard = isFirstBankCard;
	
	_addressViewModel = [[MSFAddressViewModel alloc] initWithServices:self.services];
	_executeSelected = self.addressViewModel.selectCommand;
	@weakify(self)
	_executeAddBankCard = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executeAuthSignal];
	}];

	
	RAC(self, bankAddress) = [[RACObserve(self.addressViewModel, address) ignore:nil] map:^id(id value) {
		@strongify(self)
		if (self.addressViewModel.provinceName == nil || self.addressViewModel.cityName == nil) {
			return @"";
		}
		return [NSString stringWithFormat:@"%@  %@", self.addressViewModel.provinceName,self.addressViewModel.cityName];
	}];
	RAC(self, bankBranchCityCode) = [RACObserve(self.addressViewModel, cityCode) ignore:nil];
	RAC(self, bankBranchProvinceCode) = [RACObserve(self.addressViewModel, provinceCode) ignore:nil];
	
	RAC(self, bankInfo) = [RACObserve(self, bankNO) map:^id(NSString *bankNO) {
		@strongify(self)
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
		@strongify(self)
		return [self executeResetTrade];
	}];
	RAC(self, supportBanks) = [[[self.services.httpClient fetchSupportBankInfo] ignore:nil] map:^id(id value) {
		return value;
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
	
	if (self.isFirstBankCard && self.bankInfo.support.integerValue == 2) {
		error = [NSError errorWithDomain:MSFAddBankCardViewModelErrorDomain code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"主卡不能为贷记卡",
		}];
		return [RACSignal error:error];
	}
	
	return [[self.services.httpClient addBankCardWithTransPassword:self.transPassword AndBankCardNo:[self.bankNO stringByReplacingOccurrencesOfString:@" " withString:@""] AndbankBranchProvinceCode:self.bankBranchProvinceCode AndbankBranchCityCode:self.bankBranchCityCode] doNext:^(id x) {
		[self.services.httpClient updateUser:self.services.httpClient.user];
	}];
}

- (RACSignal *)executeResetTrade {
	
	NSError *error;
	
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

	
	if (self.TradePassword.length == 0) {
		NSString *str = @"请填写交易密码";
		error = [NSError errorWithDomain:@"MSFAddBankCardViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: str,
		}];
		return [RACSignal error:error];
	}
	if (self.smsCode.length == 0) {
		NSString *str = @"请填写验证码";
		error = [NSError errorWithDomain:@"MSFAddBankCardViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: str,
		}];
		return [RACSignal error:error];
	}
	
	if (self.againTradePWD.length == 0) {
		NSString *str = @"请填写确认交易密码";
		error = [NSError errorWithDomain:@"MSFAddBankCardViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: str,
		}];
		return [RACSignal error:error];
	}
	if (![self.againTradePWD isEqualToString:self.TradePassword]) {
		NSString *str = @"交易密码和确认交易密码不一致";
		error = [NSError errorWithDomain:@"MSFAddBankCardViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: str,
		}];
		return [RACSignal error:error];
	}
	
	if (self.isFirstBankCard && self.bankInfo.support.integerValue == 2) {
		error = [NSError errorWithDomain:MSFAddBankCardViewModelErrorDomain code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"主卡不能为贷记卡",
		}];
		return [RACSignal error:error];
	}
	
	if ([self.TradePassword isSimplePWD]) {
		NSString *str = @"交易密码设置太简单，请重新输入";
		error = [NSError errorWithDomain:@"MSFAddBankCardViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: str,
		}];
		return [RACSignal error:error];
	}
	
	return [self.services.httpClient resetTradepwdWithBankCardNo:[self.bankNO stringByReplacingOccurrencesOfString:@" " withString:@""] AndprovinceCode:self.bankBranchProvinceCode AndcityCode:self.bankBranchCityCode AndsmsCode:self.smsCode AndnewTransPassword:self.TradePassword.sha256];
}

@end
