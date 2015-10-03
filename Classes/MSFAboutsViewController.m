//
// MSFSettingsViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAboutsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFUtils.h"
#import "MSFClient.h"
#import "MSFCommandView.h"
#import "MSFAboutUsCell.h"
#import "MSFProductIntroductionCell.h"
#import "MSFUserHelpCell.h"
#import "MSFBranchesCell.h"
#import "MSFAboutTableViewCell.h"

@implementation MSFAboutsViewController {
	NSArray *_imageArray;
	NSArray *_textArray;
}

#pragma mark - Lifecycle

- (instancetype)init {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MSFAboutsViewController" bundle:nil];
	self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
	if (!self) {
		
		return nil;
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"关于";
	
	_textArray = @[
		@"关于我们",
		@"产品介绍",
		@"用户帮助",
		@"网点分布",
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
	return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	cell.textLabel.text = [_textArray objectAtIndex:indexPath.row];
	[cell.textLabel setFont:[UIFont systemFontOfSize:16]];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (void)viewDidLayoutSubviews {
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.tableView setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	NSDictionary *infodictionary = [NSBundle bundleForClass:self.class].infoDictionary;
	NSString *version = infodictionary[@"CFBundleShortVersionString"];
	NSString *builds = infodictionary[@"CFBundleVersion"];
	NSString *about = [NSString stringWithFormat:@"版本号:%@ (%@)", version, builds];
	UIView *view = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 66)];
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 66)];
	[label setText:about];
	[label setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
	[label setFont:[UIFont systemFontOfSize:15]];
	[label setTextAlignment:NSTextAlignmentCenter];
	[view addSubview:label];
	return view;
}

#pragma mark - onClickBackBtn

- (void)onClickBackBtn {
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end