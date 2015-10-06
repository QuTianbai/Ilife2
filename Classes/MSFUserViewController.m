//
// MSFUserViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUserViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import <libextobjc/extobjc.h>
#import "MSFRepaymentTableViewController.h"
#import "MSFTradeTableViewController.h"
#import "MSFEditPasswordViewController.h"
#import "MSFUserInfoViewController.h"
#import "MSFUserInfomationViewController.h"
#import "MSFUtils.h"
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
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
	label.text = @"个人中心";
	label.textColor = UIColor.tintColor;
	label.font = [UIFont boldSystemFontOfSize:17];
	label.textAlignment = NSTextAlignmentCenter;
	self.navigationItem.titleView = label;
	
	[self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
	self.tableView.backgroundColor = UIColor.darkBackgroundColor;
	
	self.rowTitles = @[@[
			@"个人信息",
			@"银行卡"
		], @[
			@"设置",
			@"关于"
		]];
	self.icons = @[@[
			[UIImage imageNamed:@"icon-account-info"],
			[UIImage imageNamed:@"icon-account-repay"]
		], @[
			[UIImage imageNamed:@"icon-account-about"],
			[UIImage imageNamed:@"icon-account-intro"]
		]];
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
		case 0:{
			switch (indexPath.row) {
				case 0:
					[self userInfo];
					break;
				case 1:{
					MSFBankCardListTableViewController *vc = [[MSFBankCardListTableViewController alloc] init];
					vc.services = self.viewModel.servcies;
					[self.navigationController pushViewController:vc animated:YES];
				}
					break;
					
				default:
					break;
			}
		}
			break;
		case 1: {
			switch (indexPath.row) {
				case 0:[self settings:nil]; break;
				case 1: {
					[self pushAbout:nil];
					break;
				}
			}
			break;
		}
	}
}

#pragma mark - IBActions

- (void)userInfo {
	MSFTabBarController *tabbar = (MSFTabBarController *)self.tabBarController;
	MSFApplyCashVIewModel *viewModel = [[MSFApplyCashVIewModel alloc] initWithViewModel:tabbar.viewModel.formsViewModel];
	MSFUserInfomationViewController *vc = [[MSFUserInfomationViewController alloc] initWithViewModel:viewModel services:self.viewModel.servcies];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)repayMentPlan:(id)sender {
	MSFRepaymentTableViewController *repaymentVC = [[MSFRepaymentTableViewController alloc]initWithStyle:UITableViewStylePlain];
	repaymentVC.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:repaymentVC animated:YES];
}

- (IBAction)historyDetails:(id)sender {
	MSFTradeTableViewController *tradeVC = [[MSFTradeTableViewController alloc]initWithStyle:UITableViewStylePlain];
	tradeVC.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:tradeVC animated:YES];
}

- (IBAction)editUserInfo:(id)sender {
	MSFEditPasswordViewController *editUserinfoViewController = [[MSFEditPasswordViewController alloc] initWithViewModel:self.viewModel];
	editUserinfoViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:editUserinfoViewController animated:YES];
}

- (IBAction)appliyStatusList:(id)sender {
	MSFLoanListViewController *loanListVC = [[MSFLoanListViewController alloc] init];
	loanListVC.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:loanListVC animated:YES];
}

- (IBAction)pushAbout:(id)sender {
	MSFAboutsViewController *settingsViewController = [[MSFAboutsViewController alloc] init];
	settingsViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:settingsViewController animated:YES];
}

- (IBAction)settings:(id)sender {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass(MSFSettingsViewController.class) bundle:nil];
	UIViewController *settingsViewController = storyboard.instantiateInitialViewController;
	settingsViewController.hidesBottomBarWhenPushed = YES;
	[(id <MSFReactiveView>)settingsViewController bindViewModel:self.viewModel.authorizeViewModel];
	[self.navigationController pushViewController:settingsViewController animated:YES];
}

@end
