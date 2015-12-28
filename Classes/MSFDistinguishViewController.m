//
// MSFDistinguishViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFDistinguishViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFDistinguishViewModel.h"

@interface MSFDistinguishViewController ()

@property (nonatomic, strong) MSFDistinguishViewModel *viewModel;

@end

@implementation MSFDistinguishViewController

#pragma mark - NSObject

- (instancetype)initWithViewModel:(id)viewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  
  return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor orangeColor];
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
	[button setTitle:@"show inventory" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:button];
	button.rac_command = self.viewModel.executeInventoryCommand;
}

@end
