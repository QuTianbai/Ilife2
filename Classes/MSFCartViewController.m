//
//  MSFCartViewController.m
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCartViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MSFOrderEditViewModel.h"

#import "MSFCartCategoryCell.h"
#import "MSFCartContentCell.h"
#import "MSFCartInputCell.h"
#import "MSFCartLoanTermCell.h"
#import "MSFCartSwitchCell.h"
#import "MSFCartTrialCell.h"

#import "UIColor+Utils.h"

@interface MSFCartViewController ()

@property (nonatomic, strong) MSFOrderEditViewModel *viewModel;

@end

@implementation MSFCartViewController

- (instancetype)initWithOrderId:(NSString *)orderId
											 services:(id<MSFViewModelServices>)services {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.hidesBottomBarWhenPushed = YES;
		_viewModel = [[MSFOrderEditViewModel alloc] initWithOrderId:orderId services:services];
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
	[[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		NSLog(@"点击下一步");
	}];
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.viewModel.commodities.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == self.viewModel.commodities.count) {
		return 5;
	} else {
		return 4;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == self.viewModel.commodities.count) {
		if (indexPath.row == 2) {
			return 99.f;
		}
		if (indexPath.row == 4) {
			return 125.f;
		}
	}
	return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *reuse = [[UIView alloc] init];
	reuse.backgroundColor = UIColor.darkBackgroundColor;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width - 15, 30)];
	label.font = [UIFont systemFontOfSize:15];
	label.textColor = UIColor.themeColorNew;
	if (section == self.viewModel.commodities.count) {
		label.text = @"分期";
	} else {
		NSDictionary *mock = self.viewModel.commodities[section];
		label.text = mock[@"shop"];
	}
	[reuse addSubview:label];
	return reuse;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *identifier = [self.viewModel reuseIdentifierForCellAtIndexPath:indexPath];
	UITableViewCell<MSFReactiveView> *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (indexPath.section == self.viewModel.commodities.count) {
		[cell bindViewModel:self.viewModel atIndexPath:indexPath];
	} else {
		[cell bindViewModel:self.viewModel.commodities[indexPath.section] atIndexPath:indexPath];
	}
	return cell;
}

@end
