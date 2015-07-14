//
// MSFSettingsViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSettingsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>

#import "MSFCommandView.h"

#import "MSFAboutUsCell.h"
#import "MSFProductIntroductionCell.h"
#import "MSFUserHelpCell.h"
#import "MSFBranchesCell.h"

#import "MSFSettingTableViewCell.h"

#define SEPARATORCOLOR @"5787c0"
#define CELLBACKGROUNDCOLOR @"dce6f2"
#define TYPEFACECOLOR @"5787c0"

@implementation MSFSettingsViewController {
	NSArray *_imageArray;
	NSArray *_textArray;
}

#pragma mark - Lifecycle

- (instancetype)init {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MSFSettingsViewController" bundle:nil];
	self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
	if (!self) {
		
		return nil;
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"设置";
	
	_imageArray = @[
		@"iconfont-guanyuwomen.png",
		@"iconfont-chanpinjieshao.png",
		@"iconfont-bangzhu.png",
		@"iconfont-wangdian.png",
		@"iconfont-mianxingtubiao3gengxin.png"
	];
	
	_textArray = @[
		@"关于我们",
		@"产品介绍",
		@"用户帮助",
		@"网点分布",
		@"软件版本",
	];
}

#pragma mark - 去掉多余分割线

- (void)setExtraCellLineHidden:(UITableView *)tableView {
	
	UIView *view = [UIView new];
	
	view.backgroundColor = [UIColor clearColor];
	
	[tableView setTableFooterView:view];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	cell.textLabel.text = [_textArray objectAtIndex:indexPath.row];
	cell.imageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	if (indexPath.row == 4) {
		cell.accessoryType = UITableViewCellAccessoryNone;
		NSDictionary *infodictionary = [NSBundle bundleForClass:self.class].infoDictionary;
		NSString *version = infodictionary[@"CFBundleShortVersionString"];
		NSString *builds = infodictionary[@"CFBundleVersion"];
		NSString *about = [NSString stringWithFormat:@"%@(%@)", version, builds];
		cell.detailTextLabel.text = about;
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.row) {
		case 0:
			[self performSegueWithIdentifier:@"aboutCell" sender:self];
			break;
		case 1:
			[self performSegueWithIdentifier:@"productCell" sender:self];
			break;
		case 2:
			[self performSegueWithIdentifier:@"userHelpCell" sender:self];
			break;
		case 3:
			[self performSegueWithIdentifier:@"branchCell" sender:self];
			break;
		default:
			break;
	}
}

#pragma mark - onClickBackBtn

- (void)onClickBackBtn {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end