//
//  MSFMyOrderListDetailViewController.m
//  Finance
//
//  Created by xbm on 16/3/3.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderListDetailViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFMyOrderListViewModel.h"
#import "MSFBlurButton.h"

@interface MSFMyOrderListDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contractNo;
@property (weak, nonatomic) IBOutlet UILabel *contractStatus;
@property (weak, nonatomic) IBOutlet UILabel *contractUse;
@property (weak, nonatomic) IBOutlet UILabel *moneyCount;
@property (weak, nonatomic) IBOutlet UILabel *isInstance;
@property (nonatomic, strong) MSFMyOrderListViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *monthMoney;
@property (weak, nonatomic) IBOutlet MSFBlurButton *bottomButton;

@end

@implementation MSFMyOrderListDetailViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [[UIStoryboard storyboardWithName:@"MyOrderList" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFMyOrderListDetailViewController class])];
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"订单详情";
	@weakify(self)
	RAC(self, contractNo.text) = RACObserve(self, viewModel.appNo);
	RAC(self, contractStatus.text) = RACObserve(self, viewModel.status);
	RAC(self, contractUse.text) = RACObserve(self, viewModel.loanPurpose);
	RAC(self, moneyCount.text) = RACObserve(self, viewModel.appLmt);
	RAC(self, isInstance.hidden) = [RACObserve(self, viewModel.jionLifeInsurance) map:^id(id value) {
		@strongify(self)
		if ([self.viewModel.jionLifeInsurance isEqualToString:@"1"]) {
			return @NO;
		}
		return @YES;
	}];
	RAC(self, monthMoney.text) = RACObserve(self, viewModel.monthMoney);
	[RACObserve(self, viewModel.status) subscribeNext:^(NSString *value) {
		@strongify(self)
		if ([value isEqualToString:@"待确认合同"]) {
			self.bottomButton.hidden = NO;
			[self.bottomButton setTitle:@"确认合同" forState:UIControlStateNormal];
		} else if ([value isEqualToString:@"待支付"]) {
			self.bottomButton.hidden = NO;
			[self.bottomButton setTitle:@"支付首付" forState:UIControlStateNormal];
		} else {
			self.bottomButton.hidden = YES;
		}
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
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

@end
