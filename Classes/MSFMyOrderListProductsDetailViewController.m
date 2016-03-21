//
//  MSFMyOrderListProductsDetailViewController.m
//  Finance
//
//  Created by xbm on 16/3/3.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderListProductsDetailViewController.h"
#import "MSFMyOrderProductDetailNameCell.h"
#import "MSFMyOrderProductDetailContrractNoCell.h"
#import "MSFMyOrderProductsCell.h"
#import "MSFMyOrderProdutBottomCell.h"
#import "MSFMyOrderListProductsViewModel.h"
#import "UIColor+Utils.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFMyOrderListTravalDetailCell.h"
#import "MSFMyOrderTravalMemebersCell.h"
#import "MSFBlurButton.h"
#import "MSFPaymentViewModel.h"
#import "MSFTransactionsViewController.h"
#import "MSFInputTradePasswordViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFClient+Payment.h"
#import "MSFPayment.h"
#import "MSFDimensionalCodeViewModel.h"
#import "MSFDimensionalCodeViewController.h"
#import "NSDictionary+MSFKeyValue.h"
#import "MSFUser.h"
#import "MSFInventoryViewModel.h"

@interface MSFMyOrderListProductsDetailViewController () <MSFInputTradePasswordDelegate>

@property (nonatomic, strong) MSFMyOrderListProductsViewModel *viewModel;

@end

@implementation MSFMyOrderListProductsDetailViewController

MSFInputTradePasswordViewController *pvc;

- (instancetype)initWithViewModel:(id)viewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = @"订单详情";
	self.tableView.separatorStyle = UITableViewCellAccessoryNone;
	self.tableView.backgroundColor = [UIColor signUpBgcolor];
	@weakify(self)
	[[RACSignal combineLatest:@[RACObserve(self, viewModel.cmdtyList), RACObserve(self, viewModel.orderStatus)] ]subscribeNext:^(id x) {
		@strongify(self)
		[self.tableView reloadData];
	}];
    [[RACSignal combineLatest:@[RACObserve(self, viewModel.travelCompanInfoList), RACObserve(self, viewModel.orderStatus)] ]subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    [[RACSignal combineLatest:@[RACObserve(self, viewModel.cartType), RACObserve(self, viewModel.orderStatus)] ]subscribeNext:^(id x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.viewModel.active = YES;
	self.viewModel.active = NO;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderProductDetailNameCell class])];
			if (cell == nil) {
				cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderProductDetailNameCell class]) owner:nil options:nil].firstObject;
				}
			[(MSFMyOrderProductDetailNameCell *)cell bindViewModel:self.viewModel];
			return cell;
		} else if (indexPath.row == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderProductDetailContrractNoCell class])];
			if (cell == nil) {
				cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderProductDetailContrractNoCell class]) owner:nil options:nil].firstObject ;
			}
			[(MSFMyOrderProductDetailContrractNoCell *)cell bindViewModel:self.viewModel];
			return cell;
		}
	} else if (indexPath.section == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderProductsCell class])];
		if (cell == nil) {
			cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderProductsCell class]) owner:nil options:nil].firstObject ;
		}
		[(MSFMyOrderProductsCell *)cell bindViewModel:self.viewModel.cmdtyList[indexPath.row]];
		return cell;
	} else if (indexPath.section == 2) {
		if (indexPath.row == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderListTravalDetailCell class])];
			if (cell == nil) {
				cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderListTravalDetailCell class]) owner:nil options:nil].firstObject ;
			}
			[(MSFMyOrderListTravalDetailCell *)cell bindViewModel:self.viewModel atIndexPath:indexPath];
			return cell;
		} else {
			cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderTravalMemebersCell class])];
			if (cell == nil) {
				cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderTravalMemebersCell class]) owner:nil options:nil].firstObject ;
			}
			[(MSFMyOrderTravalMemebersCell *)cell bindViewModel:self.viewModel.cmdtyList[indexPath.row] atIndexPath:indexPath] ;
			return cell;
		}
		
	}
	cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderProdutBottomCell class])];
	if (cell == nil) {
		cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderProdutBottomCell class]) owner:nil options:nil].firstObject ;
	}
	[(MSFMyOrderProdutBottomCell *)cell bindViewModel:self.viewModel];
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	} else if (section == 3) {
		return 1;
	} else if (section == 2) {
		if ([self.viewModel.cartType isEqualToString:@"goods"] || self.viewModel.cartType.length == 0) {
			return 0;
		}
		return self.viewModel.travelCompanInfoList.count + 1;
	}
	if ([self.viewModel.cartType isEqualToString:@"travel"]) {
		return 0;
	}
	return self.viewModel.cmdtyList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 3) {
		return 72;
	} if (indexPath.section == 1) {
		return 69;
	}
	return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == 3 && ([self.viewModel.orderStatus isEqualToString:@"待支付"] ||[self.viewModel.orderStatus isEqualToString:@"待确认合同"] || [self.viewModel.orderStatus isEqualToString:@"重传资料"])) {
		return 60;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] init];
	if (section == 3) {
		view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 60);
		MSFBlurButton *button = [[MSFBlurButton alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width - 20, 40)];
		[button setTitle:@"支付首付" forState:UIControlStateNormal];
        if ([self.viewModel.orderStatus isEqualToString:@"待确认合同"]) {
            [button setTitle:@"确认合同" forState:UIControlStateNormal];
        } else if ([self.viewModel.orderStatus isEqualToString:@"重传资料"]) {
            [button setTitle:@"重传资料" forState:UIControlStateNormal];
        }
		//[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[[button rac_signalForControlEvents:UIControlEventTouchUpInside]
		subscribeNext:^(id x) {
            if ([self.viewModel.orderStatus isEqualToString:@"待确认合同"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGECONFIRMCONTRACT" object:@"3"];
                return;
            } else if ([self.viewModel.orderStatus isEqualToString:@"重传资料"]) {
                MSFInventoryViewModel *viewModel = [[MSFInventoryViewModel alloc] initWithApplicaitonNo:self.viewModel.appNo productID:self.viewModel.crProdId services:self.viewModel.services];
                [self.viewModel.services pushViewModel:viewModel];
                
            }
			if (!self.viewModel.isDownPmt) {
                MSFUser *user = [self.viewModel.services httpClient].user;
                if (!user.hasTransactionalCode) {
                    [self.viewModel.services pushSetTransPassword];
                } else {
                    pvc = [UIStoryboard storyboardWithName:@"InputTradePassword" bundle:nil].instantiateInitialViewController;
                    pvc.delegate = self;
                    [[UIApplication sharedApplication].keyWindow addSubview:pvc.view];
                }
			} else {
                MSFUser *user = [self.viewModel.services httpClient].user;
                if (!user.hasTransactionalCode) {
                    [self.viewModel.services pushSetTransPassword];
                } else {
                    MSFPaymentViewModel *viewModel = [[MSFPaymentViewModel alloc] initWithModel:self.viewModel.model services:self.viewModel.services];
                    MSFTransactionsViewController *vc = [[MSFTransactionsViewController alloc] initWithViewModel:viewModel];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
			}
		
		}];
		[view addSubview:button];
	}
	
	return view;
}

#pragma mark - MSFInputTradePasswordDelegate

- (void)getTradePassword:(NSString *)pwd type:(int)type  {
	[SVProgressHUD showWithStatus:@"正在支付..."];
	[[self.viewModel.services.httpClient paymentWithOrder:self.viewModel.model password:pwd] subscribeNext:^(id x) {
		[SVProgressHUD dismiss];
		MSFDimensionalCodeViewModel *viewModel = [[MSFDimensionalCodeViewModel alloc] initWithPayment:x order:self.viewModel.model];
		MSFDimensionalCodeViewController *vc = [[MSFDimensionalCodeViewController alloc] initWithViewModel:viewModel];
		[self.navigationController pushViewController:vc animated:YES];
	} error:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

@end
