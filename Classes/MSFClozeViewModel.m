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

static NSString *const MSFClozeViewModelErrorDomain = @"MSFClozeViewModelErrorDomain";

@interface MSFClozeViewModel ()

@property(nonatomic,strong,readwrite) MSFAddressViewModel *addressViewModel;

@end

@implementation MSFClozeViewModel

#pragma mark - Lifecycle

- (instancetype)initWithAuthorizedClient:(MSFClient *)client controller:(UIViewController *)controller {
	if (!(self = [[self.class alloc] initWithAuthorizedClient:client])) {
		return nil;
	}
	_addressViewModel = [[MSFAddressViewModel alloc] initWithController:controller needArea:NO];
	_executeSelected = self.addressViewModel.selectCommand;
	RAC(self,bankAddress) = [RACObserve(self.addressViewModel, address) ignore:nil];
	
	return self;
}

- (instancetype)initWithAuthorizedClient:(MSFClient *)client {
	self = [super init];
	if (!self) {
		return nil;
	}
	_client = client;
	_name = @"";
	_card = @"";
	_expired = [NSDate date];
	_bankNO = @"";
	_bankAddress = @"";
	_bankName = @"";
	
	@weakify(self)
	
	_executeAuth = [[RACCommand alloc] initWithEnabled:self.authoriseValidSignal
		signalBlock:^RACSignal *(id input) {
			@strongify(self)
			return [self executeAuthSignal];
		}];
	
	_executePermanent = [[RACCommand alloc]
		initWithSignalBlock:^RACSignal *(id input) {
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
		reduce:^id(
			NSString *name,
			NSString *card,
			NSString *bankname,
			NSString *bankno,
			NSString *bankaddress
		 ) {
			return @(
				name.length > 1 &&
				card.length > 1 &&
				bankname.length > 1 &&
				bankno.length > 1 &&
				bankaddress.length > 1
			);
		}];
}

#pragma mark - Private

- (RACSignal *)executeAuthSignal {
	NSError *error = nil;
	if (![self.name isChineseName] && (self.name.length < 2 || self.name.length > 20)) {
		error = [NSError errorWithDomain:MSFClozeViewModelErrorDomain code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"姓名只能输入2-20个字符的中文",
		}];
	}
	if (self.card.length != 18) {
		error = [NSError errorWithDomain:MSFClozeViewModelErrorDomain code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请输入18位身份证号",
		}];
	}
	if (self.bankName.length == 0) {
		error = [NSError errorWithDomain:MSFClozeViewModelErrorDomain code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请选择开发银行",
		}];
	}
	if (self.addressViewModel.provinceCode.length == 0) {
		error = [NSError errorWithDomain:MSFClozeViewModelErrorDomain code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请选择开发省市",
		}];
	}
	if (self.bankNO.length == 0) {
		error = [NSError errorWithDomain:MSFClozeViewModelErrorDomain code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请输入银行卡号",
		}];
	}
	if (error) {
		return [RACSignal error:error];
	}
	return [self.client
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
