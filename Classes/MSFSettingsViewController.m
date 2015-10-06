//
// MSFSettingsViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSettingsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFAuthorizeViewModel.h"
#import "MSFClient.h"
#import "MSFUser.h"

@interface MSFSettingsViewController ()

@property (nonatomic, strong) MSFAuthorizeViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UIButton *signOutButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation MSFSettingsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.signOutButton.rac_command = self.viewModel.executeSignOut;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (self.hasTransactionalCode) {
		self.titleLabel.text = @"修改交易密码";
	} else {
		self.titleLabel.text = @"设置交易密码";
	}
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController respondsToSelector:@selector(bindViewModel:)]) {
		[(id <MSFReactiveView>)segue.destinationViewController bindViewModel:self.viewModel];
	}
}

#pragma mark - Private

- (BOOL)hasTransactionalCode {
	return [self.viewModel.services httpClient].user.hasTransactionalCode;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) return 2;
	return self.hasTransactionalCode ? 2 : 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section != 1) return;
	
	NSInteger row = indexPath.row;
	switch (row) {
		case 0:
			//TODO: 更新交易密码/设置交易密码
			{
				if (self.hasTransactionalCode) {
				//  修改
				}
			}
			break;
		case 1:
			//TODO: 忘记交易密码
			break;
		default:
			break;
	}
}

@end
