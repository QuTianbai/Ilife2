//
// MSFCommodityViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCommodityCashViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFFormsViewModel.h"
#import "MSFLoanAgreementViewModel.h"

@implementation MSFCommodityCashViewModel

#pragma mark - NSObject

- (instancetype)initWithViewModel:(MSFFormsViewModel *)viewModel loanType:(MSFLoanType *)loanType barcode:(NSString *)barcode {
  self = [super init];
  if (!self) {
    return nil;
  }
	_barcode = barcode;
	_services = viewModel.services;
	_loanType = loanType;
	_formViewModel = viewModel;
	
  return self;
}

@end
