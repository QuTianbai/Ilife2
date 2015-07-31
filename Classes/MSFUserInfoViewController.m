//
// MSFUserInfoViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUserInfoViewController.h"
#import "MSFUserInfoTableViewCell.h"
#import "MSFClient.h"
#import "MSFUtils.h"
#import "MSFEdgeButton.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFClozeViewController.h"
#import "UIColor+Utils.h"
#import "MSFClient+Users.h"
#import "MSFUser.h"
#import "MSFUserViewModel.h"
#import "MSFAuthorizeViewModel.h"
#import "MSFEditPasswordViewController.h"
#import <CZPhotoPickerController/CZPhotoPickerController.h>

@interface MSFUserInfoViewController ()

@property (nonatomic, strong) NSArray *rowTitles;
@property (nonatomic, strong) NSArray *rowSubtitles;
@property (nonatomic, strong) MSFUserViewModel *viewModel;
@property (nonatomic, strong) CZPhotoPickerController *photoPickerController;

@end

@implementation MSFUserInfoViewController

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFUserInfoViewController -`dealloc`");
}

- (instancetype)initWithViewModel:(MSFUserViewModel *)viewModel {
	if (!(self = [super initWithStyle:UITableViewStyleGrouped])) {
		return nil;
	}
	_viewModel = viewModel;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"个人信息";
	self.rowTitles = @[@"姓名", @"身份证号", @"联系方式"];
	[self.tableView registerClass:MSFUserInfoTableViewCell.class forCellReuseIdentifier:@"Cell"];
	self.tableView.tableFooterView = self.tableViewFooter;
	UIView *view = [[UIView alloc] init];
	view.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 1);
	self.tableView.tableHeaderView = view;
	
	@weakify(self)
	[self.viewModel.contentUpdateSignal subscribeNext:^(id x) {
		@strongify(self)
		self.rowSubtitles = @[
			self.viewModel.username?:@"",
			self.viewModel.identifyCard?:@"",
			self.viewModel.mobile?:@"",
			];
		[self.tableView reloadData];
		if (self.viewModel.identifyCard.length == 0) {
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
			MSFClozeViewController *clozeViewController =
			[storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(MSFClozeViewController.class)];
			UINavigationController *navigationController =
			[[UINavigationController alloc] initWithRootViewController:clozeViewController];
			[self presentViewController:navigationController animated:YES completion:nil];
		}
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	self.viewModel.active = NO;
}

#pragma mark - Private

- (UIView *)tableViewFooter {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 50)];
	view.backgroundColor = [UIColor clearColor];
	MSFEdgeButton *button = MSFEdgeButton.new;
	[button setTitleColor:UIColor.themeColor forState:UIControlStateNormal];
	[button setTitle:@"退出登录" forState:UIControlStateNormal];
	[view addSubview:button];
	[button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(5, 10, 5, 10));
	}];
	@weakify(self)
	button.rac_command = self.viewModel.authorizeViewModel.executeSignOut;
	[self.viewModel.authorizeViewModel.executeSignOut.executionSignals subscribeNext:^(RACSignal *signal) {
		[signal subscribeNext:^(id x) {
			@strongify(self)
			[self.navigationController popToRootViewControllerAnimated:YES];
		}];
	}];
	
	return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return section == 0 ? 3 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MSFUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (indexPath.section == 0) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.text = self.rowTitles[indexPath.row];
		cell.detailTextLabel.text = self.rowSubtitles[indexPath.row];
	} else {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.text = @"修改密码";
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 1) {
		MSFEditPasswordViewController *vc = [[MSFEditPasswordViewController alloc] initWithViewModel:self.viewModel];
		[self.navigationController pushViewController:vc animated:YES];
	}
}

@end
