//
// MSFCouponTableViewCell.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCouponTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCouponViewModel.h"

@implementation MSFCouponTableViewCell

- (void)awakeFromNib {
	self.timeLeftLabel.transform = CGAffineTransformMakeRotation(45 * M_PI / 180);
}

- (void)bindViewModel:(MSFCouponViewModel *)viewModel {
	RAC(self, titleLabel.text) = RACObserve(viewModel, title);
	RAC(self, subtitleLabel.text) = RACObserve(viewModel, subtitle);
	RAC(self, valueLabel.text) = RACObserve(viewModel, value);
	RAC(self, introLabel.text) = RACObserve(viewModel, intro);
	RAC(self, timeRangeLabel.text) = RACObserve(viewModel, timeRange);
	RAC(self, timeLeftLabel.text) = RACObserve(viewModel, timeLeft);
	
	RAC(self, statusView.image) = [RACObserve(viewModel, imageName) map:^id(id value) {
		return [UIImage imageNamed:value];
	}];
	RAC(self, deadlineView.image) = [RACObserve(viewModel, deadlineImageName) map:^id(id value) {
		return [UIImage imageNamed:value];
	}];
	RAC(self, deadlineView.hidden) = [RACObserve(viewModel, isWarning) map:^id(id value) {
		return @(![value boolValue]);
	}];
	RAC(self, timeLeftLabel.hidden) = [RACObserve(viewModel, isWarning) map:^id(id value) {
		return @(![value boolValue]);
	}];
}

@end
