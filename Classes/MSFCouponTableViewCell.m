//
// MSFCouponTableViewCell.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCouponTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCouponViewModel.h"

@interface MSFCouponTableViewCell ()

@property (nonatomic, strong) MSFCouponViewModel *viewModel;

@end

@implementation MSFCouponTableViewCell

- (void)awakeFromNib {
	self.timeLeftLabel.transform = CGAffineTransformMakeRotation(45 * M_PI / 180);
	RAC(self, titleLabel.text) = RACObserve(self, viewModel.title);
	RAC(self, subtitleLabel.text) = RACObserve(self, viewModel.subtitle);
	RAC(self, valueLabel.text) = RACObserve(self, viewModel.value);
	RAC(self, introLabel.text) = RACObserve(self, viewModel.intro);
	RAC(self, timeRangeLabel.text) = RACObserve(self, viewModel.timeRange);
	RAC(self, timeLeftLabel.text) = RACObserve(self, viewModel.timeLeft);
	
	RAC(self, statusView.image) = [RACObserve(self, viewModel.imageName) map:^id(id value) {
		return [UIImage imageNamed:value];
	}];
	RAC(self, deadlineView.image) = [RACObserve(self, viewModel.deadlineImageName) map:^id(id value) {
		return [UIImage imageNamed:value];
	}];
	RAC(self, deadlineView.hidden) = [RACObserve(self, viewModel.isWarning) map:^id(id value) {
		return @(![value boolValue]);
	}];
	RAC(self, timeLeftLabel.hidden) = [RACObserve(self, viewModel.isWarning) map:^id(id value) {
		return @(![value boolValue]);
	}];
}

- (void)bindViewModel:(MSFCouponViewModel *)viewModel {
	self.viewModel = viewModel;
}

@end
