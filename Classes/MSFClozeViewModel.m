//
// MSFClozeViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClozeViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFClient+Users.h"
#import "NSString+Matches.h"
#import "MSFAddressViewModel.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

static NSString *const MSFClozeViewModelErrorDomain = @"MSFClozeViewModelErrorDomain";

@interface MSFClozeViewModel ()

@property (nonatomic, strong, readwrite) MSFAddressViewModel *addressViewModel;

@end

@implementation MSFClozeViewModel

#pragma mark - Lifecycle

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_name = @"";
	_card = @"";
	
	_bankNO = @"";
	_bankAddress = @"";
	_bankName = @"";
	_services = services;
	
	_addressViewModel = [[MSFAddressViewModel alloc] initWithServices:services];
	_executeSelected = self.addressViewModel.selectCommand;
	RAC(self, bankAddress) = [RACObserve(self.addressViewModel, address) ignore:nil];
	
	@weakify(self)
  _executeAuth = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    @strongify(self)
    return [self executeAuthSignal];
  }];
	
	_executePermanent = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		self.permanent = !self.permanent;
		return [RACSignal return:@(self.permanent)];
	}];
	
	return self;
}

#pragma mark - Custom Accessors

- (RACSignal *)authoriseValidSignal {
	return [RACSignal
		combineLatest:@[
			RACObserve(self, name),
			RACObserve(self, card),
			RACObserve(self, bankName),
			RACObserve(self, bankNO),
			RACObserve(self, bankAddress),
			]
		reduce:^id( NSString *name, NSString *card, NSString *bankname, NSString *bankno, NSString *bankaddress) {
			return @(
				name.length > 0 &&
				card.length > 0 &&
				bankname.length > 0 &&
				bankno.length > 0 &&
				bankaddress.length > 0
			);
		}];
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
	if (self.bankName.length == 0) {
		error = [NSError errorWithDomain:MSFClozeViewModelErrorDomain code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请选择银行名称",
		}];
    return [RACSignal error:error];
	}
	if (self.addressViewModel.provinceCode.length == 0) {
		error = [NSError errorWithDomain:MSFClozeViewModelErrorDomain code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请选择开户行地区",
		}];
    return [RACSignal error:error];
	}
	if (self.bankNO.length == 0 || self.bankNO.length < 16 ) {
		error = [NSError errorWithDomain:MSFClozeViewModelErrorDomain code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请输入正确地银行卡号",
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

@end
