//
// MSFCouponTableViewCell.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCouponTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCouponViewModel.h"

@implementation MSFCouponTableViewCell

- (void)bindViewModel:(MSFCouponViewModel *)viewModel {
	RAC(self, titleLabel.text) = RACObserve(viewModel, title);
	RAC(self, subtitleLabel.text) = RACObserve(viewModel, subtitle);
	RAC(self, valueLabel.text) = RACObserve(viewModel, value);
	RAC(self, introLabel.text) = RACObserve(viewModel, intro);
	RAC(self, timeRangeLabel.text) = RACObserve(viewModel, timeRange);
	RAC(self, timeLeftLabel.text) = RACObserve(viewModel, timeLeft);
}

@end
