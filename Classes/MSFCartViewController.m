//
//  MSFCartViewController.m
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCartViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "MSFCartViewModel.h"
#import "MSFCommodity.h"
#import "MSFCart.h"

#import "MSFCartCategoryCell.h"
#import "MSFCartContentCell.h"
#import "MSFCartInputCell.h"
#import "MSFCartLoanTermCell.h"
#import "MSFCartSwitchCell.h"
#import "MSFCartTrialCell.h"
#import "MSFTravel.h"
#import "MSFCompanion.h"

#import "UIColor+Utils.h"

@interface MSFCartViewController ()

@property (nonatomic, strong) MSFCartViewModel *viewModel;
@property (nonatomic, assign) BOOL hiddenCompanion;

@end

@implementation MSFCartViewController

- (instancetype)initWithApplicationNo:(NSString *)appNo
											       services:(id<MSFViewModelServices>)services {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.hidesBottomBarWhenPushed = YES;
		_viewModel = [[MSFCartViewModel alloc] initWithApplicationNo:appNo services:services];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = @"商品信息";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.tableView.allowsSelection = NO;
	self.tableView.backgroundColor = UIColor.darkBackgroundColor;
	[self.tableView registerClass:MSFCartCategoryCell.class forCellReuseIdentifier:@"MSFCartCategoryCell"];
	[self.tableView registerClass:MSFCartContentCell.class forCellReuseIdentifier:@"MSFCartContentCell"];
	[self.tableView registerClass:MSFCartInputCell.class forCellReuseIdentifier:@"MSFCartInputCell"];
	[self.tableView registerClass:MSFCartLoanTermCell.class forCellReuseIdentifier:@"MSFCartLoanTermCell"];
	[self.tableView registerClass:MSFCartSwitchCell.class forCellReuseIdentifier:@"MSFCartSwitchCell"];
	[self.tableView registerClass:MSFCartTrialCell.class forCellReuseIdentifier:@"MSFCartTrialCell"];
	
	UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
	UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
	nextButton.frame = CGRectMake(20, 10, footer.frame.size.width - 40, 40);
	nextButton.backgroundColor = UIColor.themeColorNew;
	[nextButton setTitle:@"下一步" forState:UIControlStateNormal];
	[nextButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
	nextButton.layer.cornerRadius = 5;
	[footer addSubview:nextButton];
	self.tableView.tableFooterView = footer;
	nextButton.rac_command = self.viewModel.executeNextCommand;

	@weakify(self)
	[RACObserve(self, viewModel.cart) subscribeNext:^(MSFCart *x) {
		@strongify(self)
		nextButton.hidden = x.cartId.length == 0;
		[self.tableView reloadData];
	}];
	
	[RACObserve(self, viewModel.barcodeInvalid) subscribeNext:^(id x) {
		@strongify(self)
		if ([x boolValue]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"无效二维码" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
			[alert show];
			[alert.rac_buttonClickedSignal subscribeNext:^(id x) {
				[self.navigationController popViewControllerAnimated:YES];
			}];
		}
	}];
	
	[self.viewModel.executeTrialCommand.executionSignals subscribeNext:^(id x) {
		[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
		[x subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
		} error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
	}];
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (!self.viewModel.cart.cartType) return 0;
	if ([self.viewModel.cart.cartType isEqualToString:@"goods"]) return self.viewModel.cart.cmdtyList.count + 1;
	if ([self.viewModel.cart.cartType isEqualToString:@"travel"]) return 3;
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.viewModel.cart.cartType isEqualToString:@"goods"])  {
		if (section == self.viewModel.cart.cmdtyList.count) {
			return 5;
		} else {
			return 4;
		}
	} else if ([self.viewModel.cart.cartType isEqualToString:@"travel"]) {
		if (section == 0) return 6; // 旅游信息
		if (section == 1) return self.viewModel.cart.companions.count * 4; // 同行人信息
		if (section == 2) return 5; // 分期信息
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
		return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (self.viewModel.cartType) {
		case MSFCartCommodity: {
				if (indexPath.section == self.viewModel.cart.cmdtyList.count) {
					if (indexPath.row == 2) {
						return 99.f;
					}
					if (indexPath.row == 4) {
						return 125.f;
					}
				}
			}
			break;
		case MSFCartTravel: {
				if (indexPath.section == 2) { // 商品试算的section
					if (indexPath.row == 2) {
						return 99.f;
					}
					if (indexPath.row == 4) {
						return 125.f;
					}
				}
				if (indexPath.section == 1 && self.hiddenCompanion) return 0.f;
				if (indexPath.section == 1 && !self.hiddenCompanion) return 44.f;
			}
			break;
		default:
			break;
	}
	return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	switch (self.viewModel.cartType) {
		case MSFCartCommodity: {
				UIView *reuse = [[UIView alloc] init];
				reuse.backgroundColor = UIColor.darkBackgroundColor;
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width - 15, 30)];
				label.font = [UIFont systemFontOfSize:15];
				label.textColor = UIColor.themeColorNew;
				if (section == self.viewModel.cart.cmdtyList.count) {
					label.text = @"分期";
				} else {
					MSFCommodity *commodity = self.viewModel.cart.cmdtyList[section];
					label.text = commodity.brandName.length > 0 ? commodity.brandName : commodity.cmdtyName;
				}
				[reuse addSubview:label];
				return reuse;
			}
			break;
		case MSFCartTravel: {
				UIView *reuse = [[UIView alloc] init];
				reuse.backgroundColor = UIColor.darkBackgroundColor;
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width - 15, 30)];
				label.font = [UIFont systemFontOfSize:15];
				label.textColor = UIColor.themeColorNew;
				if (section == 2) {
					label.text = @"分期";
				} else if (section == 0){
					MSFTravel *travel = self.viewModel.cart.travel;
					label.text = [travel.origin stringByAppendingFormat:@"-%@", travel.destination];
				} else {
					label.text = @"与申请人关系";
				}
				[reuse addSubview:label];
				if (section == 1)  {
					UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX([UIScreen mainScreen].bounds) - 30, 0, 30, 30)];
					[button setImage:[UIImage imageNamed:@"icon-arrow-down.png"] forState:UIControlStateNormal];
					[[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
						self.hiddenCompanion = !self.hiddenCompanion;
						[self.tableView reloadData];
					}];
					[reuse addSubview:button];
				}
				return reuse;
			}
			break;
		default:
			break;
	}
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (self.viewModel.cartType) {
		case MSFCartCommodity: {
				NSString *identifier = [self.viewModel reuseIdentifierForCellAtIndexPath:indexPath];
				UITableViewCell<MSFReactiveView> *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
				if (indexPath.section == self.viewModel.cart.cmdtyList.count) {
					[cell bindViewModel:self.viewModel atIndexPath:indexPath];
				} else {
					[cell bindViewModel:self.viewModel.cart.cmdtyList[indexPath.section] atIndexPath:indexPath];
				}
				return cell;
			}
			break;
		case MSFCartTravel: {
				NSString *identifier = [self.viewModel reuseIdentifierForCellAtIndexPath:indexPath];
				UITableViewCell<MSFReactiveView> *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
				if (indexPath.section == 2) { // 贷款试算视图
					[cell bindViewModel:self.viewModel atIndexPath:indexPath];
				} else if (indexPath.section == 1) {
					[cell bindViewModel:self.viewModel.cart.companions atIndexPath:indexPath];
				} else if (indexPath.section == 0) {
					[cell bindViewModel:self.viewModel.cart atIndexPath:indexPath];
				}
				return cell;
			}
			break;
		default:
			break;
	}
	
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
	cell.backgroundColor = [UIColor orangeColor];
	return cell;
}

@end
