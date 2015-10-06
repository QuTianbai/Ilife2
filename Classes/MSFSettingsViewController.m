//
// MSFSettingsViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSettingsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFAuthorizeViewModel.h"

@interface MSFSettingsViewController ()

@property (nonatomic, strong) MSFAuthorizeViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UIButton *signOutButton;

@end

@implementation MSFSettingsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.signOutButton.rac_command = self.viewModel.executeSignOut;
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
