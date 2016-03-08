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
#import "MSFApplyCashViewModel.h"
#import "MSFTabBarController.h"
#import "MSFTabBarViewModel.h"
#import "MSFSetTradePasswordTableViewController.h"
#import "MSFSetTradePasswordViewModel.h"
#import "MSFSettingsViewController.h"

#import "MSFBankCardListTableViewController.h"
#import "MSFRepaymentPlanViewController.h"
#import "MSFRepaymentPlanViewModel.h"

#import "MSFOrderListViewController.h"

#import "MSFApplyListViewModel.h"
#import "MSFLoanType.h"
#import "MSFCouponsViewModel.h"
#import "MSFCouponsViewController.h"
#import "MSFCouponsContainerViewController.h"
#import "MSFMyRepayContainerViewController.h"
#import "MSFMyRepaysViewModel.h"
#import "MSFMyOrderListContainerViewController.h"
#import "MSFBankCardListViewModel.h"
#import "MSFMyOderListsViewModel.h"

@interface MSFUserViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *rowTitles;
@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *userphoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *perentLabel;
@property (nonatomic, weak) IBOutlet UIButton *infoButton1;
@property (nonatomic, weak) IBOutlet UIButton *infoButton2;

@end

@implementation MSFUserViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(MSFUserViewModel *)viewModel {
	self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFUserViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFUserViewController class])];
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.edgesForExtendedLayout = UIRectEdgeTop;
	self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
	self.navigationItem.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
	self.tableView.bounces = NO;
	
	RAC(self, usernameLabel.text) = [RACObserve(self, viewModel.services.httpClient.user.name) map:^id(id value) {
		return [NSString stringWithFormat:@"%@, 您好", value];
	}];
	RAC(self, userphoneLabel.text) = [RACObserve(self, viewModel.services.httpClient.user.mobile) map:^id(id value) {
		return [NSString stringWithFormat:@"手机号: %@", value];
	}];
	@weakify(self)
	RAC(self, perentLabel.text) = [RACObserve(self, viewModel.percent) doNext:^(id x) {
		@strongify(self)
		if ([x isEqualToString:@"100%"]) {
			[self.infoButton1 setTitle:@"更新信息" forState:UIControlStateNormal];
		}
	}];
	self.infoButton1.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self updateUserSignal];
	}];
	self.infoButton2.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self updateUserSignal];
	}];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  UINavigationBar *navigationBar = self.navigationController.navigationBar;
  navigationBar.tintColor = UIColor.whiteColor;
  self.shadowImage = navigationBar.shadowImage;
  self.backgroundImage = [navigationBar backgroundImageForBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
  [navigationBar setBackgroundImage:[UIImage new]
                     forBarPosition:UIBarPositionAny
                         barMetrics:UIBarMetricsDefault];
  [navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  UINavigationBar *navigationBar = self.navigationController.navigationBar;
  [navigationBar setBackgroundImage:self.backgroundImage
                     forBarPosition:UIBarPositionAny
                         barMetrics:UIBarMetricsDefault];
  [navigationBar setShadowImage:self.shadowImage];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.section) {
		case 0: {
			switch (indexPath.row) {
				case 0:
					[self orderList];
					break;
				case 1:
					[self repaymentPlan];
					break;
				case 2:
					[self bankCardList];
					break;
				case 3:
					[self couponsList];
					break;
				case 4:
				//TODO: 缺少扫一扫
					break;
				default: break;
			}
			break;
		}
		case 1: {
			switch (indexPath.row) {
				case 0:
					[self pushAbout];
					break;
				case 1:
					[self settings];
					break;
			}
			break;
		}
	}
}

#pragma mark - IBActions

- (void)userInfo {
	MSFUserViewModel *viewModel = [[MSFUserViewModel alloc] initWithServices:self.viewModel.services];
	MSFUserInfomationViewController *vc = [[MSFUserInfomationViewController alloc] initWithViewModel:viewModel];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)repaymentPlan {
	MSFMyRepaysViewModel *viewmodel = [[MSFMyRepaysViewModel alloc] initWithservices:self.viewModel.services];
	MSFMyRepayContainerViewController *vc = [[MSFMyRepayContainerViewController alloc] initWithViewModel:viewmodel];
	vc.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)bankCardList {
	MSFBankCardListViewModel *viewModel = [[MSFBankCardListViewModel alloc] initWithServices:self.viewModel.services];
	MSFBankCardListTableViewController *vc = [[MSFBankCardListTableViewController alloc] initWithViewModel:viewModel];
	vc.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)orderList {
//	MSFOrderListViewController *vc = [[MSFOrderListViewController alloc] initWithServices:self.viewModel.servcies];
	MSFMyOderListsViewModel *viewModel = [[MSFMyOderListsViewModel alloc] initWithservices:self.viewModel.services];
	MSFMyOrderListContainerViewController *vc = [[MSFMyOrderListContainerViewController alloc] initWithViewModel:viewModel];
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

- (void)couponsList {
	MSFCouponsViewModel *viewModel = [[MSFCouponsViewModel alloc] initWithServices:self.viewModel.services];
	MSFCouponsContainerViewController *vc = [[MSFCouponsContainerViewController alloc] initWithViewModel:viewModel];
	vc.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:vc animated:YES];
}

- (RACSignal *)updateUserSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFUserViewModel *viewModel = [[MSFUserViewModel alloc] initWithServices:self.viewModel.services];
		MSFUserInfomationViewController *vc = [[MSFUserInfomationViewController alloc] initWithViewModel:viewModel];
		[self.navigationController pushViewController:vc animated:YES];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
