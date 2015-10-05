//
// MSFSettingsViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSettingsViewController.h"

@interface MSFSettingsViewController ()

@property (nonatomic, strong) id viewModel;

@end

@implementation MSFSettingsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController respondsToSelector:@selector(bindViewModel:)]) {
		[(id <MSFReactiveView>)segue.destinationViewController bindViewModel:self.viewModel];
	}
}

@end
