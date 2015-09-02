//
// MSFInventoryViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFInventoryViewController.h"
#import "MSFInventoryViewModel.h"

@interface MSFInventoryViewController ()

@property (nonatomic, strong) MSFInventoryViewModel *viewModel;

@end

@implementation MSFInventoryViewController

- (instancetype)initWithViewModel:(id)viewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.viewModel.active = NO;
}

@end
