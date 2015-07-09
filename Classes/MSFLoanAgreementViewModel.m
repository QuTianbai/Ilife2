//
// MSFLoanAgreementViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanAgreementViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFApplyCash.h"
#import "MSFFormsViewModel.h"
#import "MSFApplyInfo.h"

@implementation MSFLoanAgreementViewModel

- (instancetype)initWithFromsViewModel:(MSFFormsViewModel *)formsViewModel product:(MSFMonths *)product {
  self = [super init];
  if (!self) {
    return nil;
  }
	_formsViewModel = formsViewModel;
	_product = product;
	@weakify(self)
	[[RACObserve(self, applyCash) ignore:nil] subscribeNext:^(MSFApplyCash *applyCash) {
		@strongify(self)
		self.formsViewModel.model.loanId = applyCash.applyID;
		self.formsViewModel.model.personId = applyCash.personId;
		self.formsViewModel.model.applyNo = applyCash.applyNo;
	}];
	
	_executeRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self.formsViewModel submitSignalWithPage:1];
	}];
	
  return self;
}

@end
