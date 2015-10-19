//
// MSFClozeViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClozeViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFClient+Users.h"
#import "NSString+Matches.h"
#import "MSFAddressViewModel.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import <FMDB/FMDB.h>
#import "MSFBankInfoModel.h"

static NSString *const MSFClozeViewModelErrorDomain = @"MSFClozeViewModelErrorDomain";

@interface MSFClozeViewModel ()

@property (nonatomic, strong) FMDatabase *fmdb;

@property (nonatomic, strong, readwrite) MSFAddressViewModel *addressViewModel;

@property (nonatomic, copy) NSString *oldBankNo;

@property (nonatomic, assign) BOOL isSameBankNo;

@end

@implementation MSFClozeViewModel

#pragma mark - Lifecycle

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	[self initialize];
	_name = @"";
	_card = @"";
	
	_bankNO = @"";
	_bankAddress = @"";
	_bankName = @"";
	_services = services;
	_oldBankNo = @"";
	//_bankInfo = [[MSFBankInfoModel alloc] init];
	
	_addressViewModel = [[MSFAddressViewModel alloc] initWithServices:services];
	_executeSelected = self.addressViewModel.selectCommand;
	
	RAC(self, bankAddress) = [RACObserve(self.addressViewModel, address) ignore:nil];
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
	
	@weakify(self)
	_executeAuth = [[RACCommand alloc] initWithEnabled:[self submitValidSignal] signalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executeAuthSignal];
	}];
//  _executeAuth = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//    @strongify(self)
//    return [self executeAuthSignal];
//  }];
	
	_executePermanent = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		self.permanent = !self.permanent;
		return [RACSignal return:@(self.permanent)];
	}];
	
	return self;
}

#pragma mark - Private

- (RACSignal *)executeAuthSignal {
	NSError *error = nil;
  if (![self.name isChineseName]||([self.name isChineseName] && (self.name.length < 2 || self.name.length > 20))) {
    NSString *str = @"姓名只能输入2-20个字符的中文";
    if (self.name.length == 0) {
      str = @"请输入您的名字";
    }
    error = [NSError errorWithDomain:MSFClozeViewModelErrorDomain code:0 userInfo:@{
      NSLocalizedFailureReasonErrorKey: str,
      }];
    return [RACSignal error:error];
  }
	if (self.card.length != 18) {
		error = [NSError errorWithDomain:MSFClozeViewModelErrorDomain code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请输入18位身份证号",
		}];
    return [RACSignal error:error];
	}
  if (!self.expired && !self.permanent ) {
    error = [NSError errorWithDomain:MSFClozeViewModelErrorDomain code:0 userInfo:@{
      NSLocalizedFailureReasonErrorKey: @"请选择身份证过期日期",
                                                                                    }];
    return [RACSignal error:error];
  }
	if (self.addressViewModel.provinceCode.length == 0) {
		error = [NSError errorWithDomain:MSFClozeViewModelErrorDomain code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请选择开户行地区",
		}];
    return [RACSignal error:error];
	}
	if (self.bankNO.length == 0 || [self.bankNO stringByReplacingOccurrencesOfString:@" " withString:@""].length < 14 || [self.bankNO stringByReplacingOccurrencesOfString:@" " withString:@""].length != self.maxSize.integerValue ) {
		NSString *str = @"请输入正确的银行卡号";
		if (self.bankNO.length == self.maxSize.integerValue) {
			str = @"你的银行卡号长度有误，请修改后再试";
		}
		error = [NSError errorWithDomain:MSFClozeViewModelErrorDomain code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: str,
		}];
    return [RACSignal error:error];
	}
	return [self.services.httpClient
		realnameAuthentication:self.name
		idcard:self.card
          expire:self.expired
		session:self.permanent
		province:self.addressViewModel.provinceCode
		city:self.addressViewModel.cityCode
		bank:self.bankCode
		card:self.bankNO];
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
//		if ( [self.bankNO isEqualToString:@""] || tempBankNo.length > 10 || [tempBankNo containsString:self.oldBankNo]) {
//			return nil;
//		}
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
				
			default:
			break;
		}
		return [NSNumber numberWithInt:re];
//		return @( support == nil || support.intValue == 0 || support.intValue != 1 || support.intValue != 2 || support.intValue ==3);
	}];
}

@end
