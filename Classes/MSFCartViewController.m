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
#import "MSFMyOrderCmdViewModel.h"
#import "MSFMyOrderProductsCell.h"
#import "MSFMyOrderListTravalDetailCell.h"
#import "MSFMyOrderTravalMemebersCell.h"

@interface MSFCartViewController ()

@property (nonatomic, strong) MSFCartViewModel *viewModel;
@property (nonatomic, assign) BOOL hiddenCompanion;

@end

@implementation MSFCartViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.hidesBottomBarWhenPushed = YES;
		_viewModel = viewModel;
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
    [self.tableView registerClass:MSFCartContentCell.class forCellReuseIdentifier:@"MSFCartContentCell"];
    [self.tableView registerClass:MSFCartCategoryCell.class forCellReuseIdentifier:@"MSFCartCategoryCell"];

	[self.tableView registerClass:MSFCartInputCell.class forCellReuseIdentifier:@"MSFCartInputCell"];
	[self.tableView registerClass:MSFCartLoanTermCell.class forCellReuseIdentifier:@"MSFCartLoanTermCell"];
	[self.tableView registerClass:MSFCartSwitchCell.class forCellReuseIdentifier:@"MSFCartSwitchCell"];
	[self.tableView registerClass:MSFCartTrialCell.class forCellReuseIdentifier:@"MSFCartTrialCell"];
	
	UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
	UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
	nextButton.frame = CGRectMake(20, 50, footer.frame.size.width - 40, 40);
	nextButton.backgroundColor = UIColor.themeColorNew;
	[nextButton setTitle:@"下一步" forState:UIControlStateNormal];
	[nextButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
	nextButton.layer.cornerRadius = 5;
	[footer addSubview:nextButton];
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth([UIScreen mainScreen].bounds), 30)];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 110, 30)];
	label.font = [UIFont systemFontOfSize:13];
	label.text = @"我已经阅读且同意";
	label.textColor = [UIColor darkGrayColor];
	[view addSubview:label];
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 15, 15)];
	imageView.image = [UIImage imageNamed:@"icon-protocol-normal.png"];
	imageView.highlightedImage = [UIImage imageNamed:@"icon-protocol-selected.png"];
	[view addSubview:imageView];
	
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(140, 0, 160, 30)];
	[button setTitle:@"《个人消费信贷申请协议》" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor colorWithRed:0.086 green:0.565 blue:0.980 alpha:1.000] forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont systemFontOfSize:13]];
	[view addSubview:button];
	button.rac_command = self.viewModel.executeProtocolCommand;
	
	UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 30)];
	[view addSubview:button1];
	RAC(imageView, highlighted) = RACObserve(button1, selected);
	RAC(self, viewModel.hasAgreeProtocol) = RACObserve(button1, selected);
	[[button1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
		x.selected = !x.selected;
	}];
	
	[footer addSubview:view];
	self.tableView.tableFooterView = footer;
	nextButton.rac_command = self.viewModel.executeNextCommand;

	@weakify(self)
	[RACObserve(self, viewModel.cart) subscribeNext:^(MSFCart *x) {
		@strongify(self)
		nextButton.hidden = x.cartId.length == 0;
		[self.tableView reloadData];
	}];
	
	[self.viewModel.executeTrialCommand.executionSignals subscribeNext:^(id x) {
		[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
		[x subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
		} error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
	}];
	
	__block UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
	[self.viewModel.executeTrialCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD dismiss];
		alertView.message = error.userInfo[NSLocalizedFailureReasonErrorKey];
		if (!alertView.isVisible)  [alertView show];
	}];
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (!self.viewModel.cart.cartType) return 0;
	if ([self.viewModel.cart.cartType isEqualToString:MSFCartCommodityIdentifier])
        return 2;//return self.viewModel.cart.cmdtyList.count + 1;
	if ([self.viewModel.cart.cartType isEqualToString:MSFCartTravelIdentifier]) return 2;
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.viewModel.cart.cartType isEqualToString:MSFCartCommodityIdentifier])  {
        if (section == 0) {
            return self.viewModel.cart.cmdtyList.count;
        }
        return 4;
//		if (section == self.viewModel.cart.cmdtyList.count) {
//			return 4;
//		} else {
//			return 4;
//		}
	} else if ([self.viewModel.cart.cartType isEqualToString:MSFCartTravelIdentifier]) {
		if (section == 0) return self.viewModel.cart.companions.count + 1; // 旅游信息
		//if (section == 1) return self.viewModel.cart.companions.count * 4; // 同行人信息
		if (section == 1) return 4; // 分期信息
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
	if ([self.viewModel.cart.cartType isEqualToString:MSFCartCommodityIdentifier]) {
        if (indexPath.section == 0) {
            return 69;
        }
		if (indexPath.section == 1) {
			if (indexPath.row == 2) {
				return 150.f;
			}
			if (indexPath.row == 4) {
				return 125.f;
			}
		}
	} else if ([self.viewModel.cart.cartType isEqualToString:MSFCartTravelIdentifier]) {
		if (indexPath.section == 1) { // 商品试算的section 分期
			if (indexPath.row == 2) {
				return 150.f;
			}
			if (indexPath.row == 4) {
				return 125.f;
			}
		}
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 63;
            } else {
                return 72;
            }
        }
//		if (indexPath.section == 1 && self.hiddenCompanion) return 0.f;
//		if (indexPath.section == 1 && !self.hiddenCompanion) return 44.f;
	}
	return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if ([self.viewModel.cart.cartType isEqualToString:MSFCartCommodityIdentifier]) {
		UIView *reuse = [[UIView alloc] init];
		reuse.backgroundColor = UIColor.darkBackgroundColor;
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width - 15, 30)];
		label.font = [UIFont systemFontOfSize:15];
		label.textColor = UIColor.themeColorNew;
		if (section == 1) {
			label.text = @"分期";
        } else if (section == 0) {
            label.text = @"商品信息";
        }
//        else {
//			MSFCommodity *commodity = self.viewModel.cart.cmdtyList[section];
//			label.text = commodity.brandName.length > 0 ? commodity.brandName : commodity.cmdtyName;
//		}
		[reuse addSubview:label];
		return reuse;
	} else if ([self.viewModel.cart.cartType isEqualToString:MSFCartTravelIdentifier]) {
		UIView *reuse = [[UIView alloc] init];
		reuse.backgroundColor = UIColor.darkBackgroundColor;
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width - 15, 30)];
		label.font = [UIFont systemFontOfSize:15];
		label.textColor = UIColor.themeColorNew;
		if (section == 1) {
			label.text = @"分期";
		} else if (section == 0){
			label.text = @"商品信息";
		} else {
			label.text = @"同行人信息";
		}
		[reuse addSubview:label];
//		if (section == 1)  {
//			UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX([UIScreen mainScreen].bounds) - 30, 0, 30, 30)];
//			[button setImage:[UIImage imageNamed:@"icon-arrow-down.png"] forState:UIControlStateNormal];
//			[[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//				self.hiddenCompanion = !self.hiddenCompanion;
//				[self.tableView reloadData];
//			}];
//			[reuse addSubview:button];
//		}
		return reuse;
	}
	
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.viewModel.cart.cartType isEqualToString:MSFCartCommodityIdentifier]) {
		NSString *identifier = [self.viewModel reuseIdentifierForCellAtIndexPath:indexPath];
		UITableViewCell<MSFReactiveView> *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
		if (indexPath.section == 1) {
			[cell bindViewModel:self.viewModel atIndexPath:indexPath];
		} else {
      cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderProductsCell class])];
      if (cell == nil) {
          cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderProductsCell class]) owner:nil options:nil].firstObject ;
      }
      [(MSFMyOrderProductsCell *)cell bindViewModel:[[MSFMyOrderCmdViewModel alloc] initWithModel:self.viewModel.cart.cmdtyList[indexPath.row]]];
    }
		return cell;
	} else if ([self.viewModel.cart.cartType isEqualToString:MSFCartTravelIdentifier]) {
		NSString *identifier = [self.viewModel reuseIdentifierForCellAtIndexPath:indexPath];
		UITableViewCell<MSFReactiveView> *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
		if (indexPath.section == 1) { // 贷款试算视图
			[cell bindViewModel:self.viewModel atIndexPath:indexPath];
    } else if (indexPath.section == 0) {
      if (indexPath.row == 0) {
          cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderListTravalDetailCell class])];
          if (cell == nil) {
              cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderListTravalDetailCell class]) owner:nil options:nil].firstObject ;
          }
          [(MSFMyOrderListTravalDetailCell *)cell bindViewModel:self.viewModel atIndexPath:indexPath];
      } else {
          cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderTravalMemebersCell class])];
          if (cell == nil) {
              cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderTravalMemebersCell class]) owner:nil options:nil].firstObject ;
          }
          [(MSFMyOrderTravalMemebersCell *)cell bindViewModel:self.viewModel.cart atIndexPath:indexPath] ;
      }
		}
		return cell;
	}
	
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
	cell.backgroundColor = [UIColor orangeColor];
	return cell;
}

@end
