//
// MSFUserViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUserViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import <Mantle/EXTScope.h>
#import "MSFEditPasswordViewController.h"
#import "MSFUserInfomationViewController.h"
#import "MSFClient.h"
#import "MSFUser.h"
#import "MSFClient+Users.h"
#import "MSFLoanListViewController.h"
#import "UIColor+Utils.h"
#import "MSFAboutsViewController.h"
#import "MSFUserViewModel.h"
#import "MSFApplyCashVIewModel.h"
#import "MSFTabBarController.h"
#import "MSFTabBarViewModel.h"
#import "MSFSetTradePasswordTableViewController.h"
#import "MSFSetTradePasswordViewModel.h"
#import "MSFSettingsViewController.h"

#import "MSFBankCardListTableViewController.h"
#import "MSFRepaymentPlanViewController.h"
#import "MSFRepaymentViewModel.h"

#import "MSFApplyListViewModel.h"

@interface MSFUserViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *rowTitles;
@property (nonatomic, strong) NSArray *icons;

@end

@implementation MSFUserViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(MSFUserViewModel *)viewModel {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
	self.tableView.backgroundColor = UIColor.darkBackgroundColor;
	self.rowTitles = @[@[@"个人信息",
											 @"申请记录",
											 @"还款计划",
											 @"银行卡"],
										 @[@"设置",
											 @"关于"]];
	self.icons = @[@[[UIImage imageNamed:@"icon-account-info"],
									 [UIImage imageNamed:@"icon-account-apply"],
									 [UIImage imageNamed:@"icon-account-repay"],
									 [UIImage imageNamed:@"icon-account-bankCard"]],
								 @[[UIImage imageNamed:@"icon-account-settings"],
									 [UIImage imageNamed:@"icon-account-about"]]];
	NSLog(@"%@", self.icons);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.rowTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.rowTitles[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0: return 0.1;
		case 1: return 32;
		case 2: return 10;
		default:return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	cell.textLabel.font = [UIFont systemFontOfSize:16];
	cell.textLabel.text	 = self.rowTitles[indexPath.section][indexPath.row];
	cell.imageView.image = self.icons[indexPath.section][indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.section) {
		case 0: {
			switch (indexPath.row) {
				case 0:
					[self userInfo];
					break;
				case 1:
					[self applyList];
					break;
				case 2:
					[self repaymentPlan];
					break;
				case 3:
					[self bankCardList];
					break;
				default: break;
			}
		}
			break;
		case 1: {
			switch (indexPath.row) {
				case 0:
					[self settings];
					break;
				case 1:
					[self pushAbout];
					break;
			}
			break;
		}
	}
}

#pragma mark - IBActions

- (void)userInfo {
	MSFTabBarController *tabbar = (MSFTabBarController *)self.tabBarController;
	MSFApplyCashVIewModel *viewModel = [[MSFApplyCashVIewModel alloc] initWithViewModel:tabbar.viewModel.formsViewModel productType:@""];
	MSFUserInfomationViewController *vc = [[MSFUserInfomationViewController alloc] initWithViewModel:viewModel services:self.viewModel.servcies];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)applyList {
	MSFApplyListViewModel *viewModel = [[MSFApplyListViewModel alloc] initWithServices:self.viewModel.servcies];
	MSFLoanListViewController *applyList = [[MSFLoanListViewController alloc] initWithViewModel:viewModel];
	[self.navigationController pushViewController:applyList animated:YES];
}

- (void)repaymentPlan {
	MSFRepaymentViewModel *viewmodel = [[MSFRepaymentViewModel alloc] initWithServices:self.viewModel.servcies];
	MSFRepaymentPlanViewController *repayViewController = [[MSFRepaymentPlanViewController alloc] initWithViewModel:viewmodel];
	repayViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:repayViewController animated:YES];
}

- (void)bankCardList {
	MSFBankCardListTableViewController *vc = [[MSFBankCardListTableViewController alloc] initWithViewModel:self.viewModel.bankCardListViewModel];
	vc.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)pushAbout {
	MSFAboutsViewController *settingsViewController = [[MSFAboutsViewController alloc] init];
	settingsViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:settingsViewController animated:YES];
}

- (void)settings {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass(MSFSettingsViewController.class) bundle:nil];
	UIViewController *settingsViewController = storyboard.instantiateInitialViewController;
	settingsViewController.hidesBottomBarWhenPushed = YES;
	[(id <MSFReactiveView>)settingsViewController bindViewModel:self.viewModel.authorizeViewModel];
	[self.navigationController pushViewController:settingsViewController animated:YES];
}

@end
