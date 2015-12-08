//
//  MSFLifeInsuranceViewModel.h
//  Finance
//
//  Created by xbm on 15/10/13.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class MSFLoanType;

@interface MSFLifeInsuranceViewModel : RVMViewModel

// Returns a signal which send HTML content
- (RACSignal *)lifeInsuranceHTMLSignal;

- (instancetype)initWithServices:(id<MSFViewModelServices>)services ProductID:(NSString *)productID __deprecated_msg("Use `-initWithServices:loanType:` instead");

// Create a new MSFLifeInsuranceViewModel object
//
// services - The httpClient provider
// loanType - The loan product group identifier
//
// Returns a new MSFLifeInsuranceViewModel
- (instancetype)initWithServices:(id<MSFViewModelServices>)services loanType:(MSFLoanType *)loanType;

@end
