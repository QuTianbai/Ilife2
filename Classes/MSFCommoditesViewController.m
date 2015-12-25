//
// MSFCommoditesViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCommoditesViewController.h"
#import "MSFCommoditesViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFCommoditesViewController ()

@property (nonatomic, strong) MSFCommoditesViewModel *viewModel;

@end

@implementation MSFCommoditesViewController

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
	self.view.backgroundColor = [UIColor whiteColor];
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
	[button setTitle:@"show face agreement" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:button];
	button.rac_command = self.viewModel.executeAgreementCommand;
}

@end
