//
// MSFPlanView.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFPlanView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFPlanViewModel.h"

@interface MSFPlanView ()

@property (nonatomic, weak) MSFPlanViewModel *viewModel;

@end

@implementation MSFPlanView

#pragma mark - NSObject

- (instancetype)init {
  return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (!(self = [super initWithFrame:frame])) {
    return nil;
  }
	self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 20);
	self.font = [UIFont systemFontOfSize:15];
	self.textAlignment = NSTextAlignmentCenter;
	
	RAC(self, text) = RACObserve(self, viewModel.text);
	
  return self;
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(MSFPlanViewModel *)viewModel {
	self.viewModel = viewModel;
}

@end
