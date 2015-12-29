//
// MSFCommoditesViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCommoditesViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFFormsViewModel.h"
#import "MSFLoanAgreementViewModel.h"

@implementation MSFCommoditesViewModel

#pragma mark - NSObject

- (instancetype)initWithViewModel:(MSFFormsViewModel *)viewModel loanType:(MSFLoanType *)loanType barcode:(MSFBarcode *)barcode {
  self = [super init];
  if (!self) {
    return nil;
  }
	_barcode = barcode;
	_services = viewModel.services;
	_loanType = loanType;
	_formViewModel = viewModel;
	
	_executeAgreementCommand = [[RACCommand alloc] initWithEnabled:self.agreementValidSignal signalBlock:^RACSignal *(id input) {
		return self.executeAgreementSignal;
	}];
	
  return self;
}

#pragma mark - Private

- (RACSignal *)agreementValidSignal {
	//TODO: 需要判断条件，是否满足进入协议界面
	return [RACSignal return:@YES];
}

- (RACSignal *)executeAgreementSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFLoanAgreementViewModel *viewModel = [[MSFLoanAgreementViewModel alloc] initWithApplicationViewModel:self];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
