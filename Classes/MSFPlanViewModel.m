//
// MSFPlanViewModel.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFPlanViewModel.h"
#import "MSFTrial.h"

@implementation MSFPlanViewModel

- (instancetype)initWithModel:(id)model {
  self = [super init];
  if (!self) {
    return nil;
  }
	
	_model = model;
	_text = [NSString stringWithFormat:@"%@       ¥%@(含寿险金额¥%@)", self.model.loanTerm, self.model.loanFixedAmt, self.model.lifeInsuranceAmt];
	
  return self;
}

- (instancetype)initWithModel:(id)model services:(id <MSFViewModelServices>)services {
  return self;
}

- (instancetype)initWithModel:(id)model viewModel:(id)viewModel services:(id <MSFViewModelServices>)services {
  return nil;
}

@end
