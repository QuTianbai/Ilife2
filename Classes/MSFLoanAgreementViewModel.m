//
// MSFLoanAgreementViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanAgreementViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFApplicationResponse.h"
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFAddress.h"
#import "MSFApplyCashVIewModel.h"
#import "MSFClient+Agreements.h"
#import "MSFSocialInsuranceCashViewModel.h"

@implementation MSFLoanAgreementViewModel

- (instancetype)initWithApplicationViewModel:(id <MSFApplicationViewModel>)applicationViewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_applicationViewModel = applicationViewModel;
	_services = self.applicationViewModel.services;
	
	@weakify(self)
	_executeRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		if ([self.applicationViewModel isKindOfClass:MSFApplyCashVIewModel.class]) {
			return [(MSFApplyCashVIewModel *)self.applicationViewModel submitSignalWithStatus:@"0"];
		}
		if ([self.applicationViewModel isKindOfClass:MSFSocialInsuranceCashViewModel.class]) {
			//TODO: 提交社保贷协议数据
			return [RACSignal empty];
		}
		return RACSignal.empty;
	}];
	
	return self;
}

- (instancetype)initWithFromsViewModel:(MSFApplyCashVIewModel *)formsViewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_product = formsViewModel;
	_formsViewModel = formsViewModel;
	_services = formsViewModel.services;
	@weakify(self)
	_executeRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self.formsViewModel submitSignalWithStatus:@"0"];
	}];
	
	return self;
}

- (RACSignal *)loanAgreementSignal {
	if ([self.applicationViewModel isKindOfClass:MSFApplyCashVIewModel.class]) {
		return [self.services.httpClient fetchLoanAgreementWithProduct:self.applicationViewModel];
	}
	if ([self.applicationViewModel isKindOfClass:MSFSocialInsuranceCashViewModel.class]) {
		//TODO: 加载社保贷协议HTML
		return [RACSignal empty];
	}
	return [RACSignal empty];
}

@end
