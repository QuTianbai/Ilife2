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
#import "MSFUtils.h"
#import "MSFClient.h"
#import "MSFUser.h"
#import "MSFClient+Users.h"
#import "MSFLoanListViewController.h"
#import "UIButton+BottomTitles.h"
#import "UIColor+Utils.h"
#import "MSFSettingsViewController.h"

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
	label.text = @"我的账户";
	label.textColor = [UIColor tintColor];
	label.font = [UIFont boldSystemFontOfSize:17];
	label.textAlignment = NSTextAlignmentCenter;
	self.navigationItem.titleView = label;
	
	[self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
	[self.tableView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"sectionHeader"];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	//self.tableView.tableHeaderView = self.tableViewHeader;
	self.tableView.backgroundColor = [UIColor darkBackgroundColor];
	
	self.rowTitles = @[@[@"个人信息"],
										 @[@"申请记录",
											 @"还款计划",
											 @"历史交易"],
										 @[@"关于"]];
	self.icons = @[@[[UIImage imageNamed:@"icon-account-info"]],
								 @[[UIImage imageNamed:@"icon-account-apply"],
									 [UIImage imageNamed:@"icon-account-repay"],
									 [UIImage imageNamed:@"icon-account-history"]],
								 @[[UIImage imageNamed:@"icon-account-about"]]];
}

#pragma mark - Private
/*
- (UIView *)tableViewHeader {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 170)];
	view.backgroundColor = [UIColor whiteColor];
	
	UIImageView *backgroundView = UIImageView.new;
	backgroundView.image = [UIImage imageNamed:@"bg-account-header"];
	[view addSubview:backgroundView];
	[backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(view);
	}];
	
	UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[avatarButton setBackgroundImage:[UIImage imageNamed:@"icon-avatar-placeholder"] forState:UIControlStateNormal];
	[view addSubview:avatarButton];
	[avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@75);
		make.width.equalTo(@75);
		make.center.equalTo(view);
	}];
	
	UILabel *label = UILabel.new;
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.text = [MSFUtils.httpClient user].name;
	label.hidden = YES;
	[view addSubview:label];
	[label mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(avatarButton.mas_bottom).offset(-10);
		make.centerX.equalTo(avatarButton);
	}];
	
	@weakify(self)
	[[avatarButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		subscribeNext:^(id x) {
			@strongify(self)
			MSFUserInfoViewController *userinfoViewController = [[MSFUserInfoViewController alloc] initWithViewModel:self.viewModel];
			userinfoViewController.hidesBottomBarWhenPushed = YES;
			[self.navigationController pushViewController:userinfoViewController animated:YES];
	}];
	
	self.navigationItem.rightBarButtonItem =
		[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-setting"]
		style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.rightBarButtonItem.rac_command =
		[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			@strongify(self)
			MSFSettingsViewController *settingsViewController = [[MSFSettingsViewController alloc] init];
			settingsViewController.hidesBottomBarWhenPushed = YES;
			[self.navigationController pushViewController:settingsViewController animated:YES];
			return [RACSignal empty];
		}];
 
	return view;
}*/

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return self.rowTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.rowTitles[section] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0: return 0.1;
		case 1: return 32;
		case 2: return 10;
		default:return 0;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"sectionHeader"];
	if (section == 1) {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 6, 100, 20)];
		label.text = @"贷款信息";
		label.textColor = [UIColor tintColor];
		label.font = [UIFont boldSystemFontOfSize:13];
		[view.contentView addSubview:label];
	}
	return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
	cell.textLabel.text	 = self.rowTitles[indexPath.section][indexPath.row];
	cell.imageView.image = self.icons[indexPath.section][indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	switch (indexPath.section) {
		case 0:[self userInfo];break;
		case 1: {
			switch (indexPath.row) {
				case 0:[self appliyStatusList:nil];break;
				case 1:[self repayMentPlan:nil];break;
				case 2:[self historyDetails:nil];break;
			}
		}
		case 2: break;
	}
}

#pragma mark - IBActions

- (void) userInfo {
	MSFUserInfoViewController *userinfoViewController = [[MSFUserInfoViewController alloc] initWithViewModel:self.viewModel];
	userinfoViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:userinfoViewController animated:YES];
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

@end
