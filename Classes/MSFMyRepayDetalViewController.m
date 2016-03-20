//
//  MSFMyRepayDetalViewController.m
//  Finance
//
//  Created by xbm on 16/2/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayDetalViewController.h"
#import "MSFBlurButton.h"
#import "MSFMyRepayDetailViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFTableViewBindingHelper.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "MSFMyRepayDetailTableViewCell.h"

@interface MSFMyRepayDetalViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *repayMoneyCountLB;
@property (weak, nonatomic) IBOutlet UIButton *repayBT;
@property (weak, nonatomic) IBOutlet UILabel *contractTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repayDay;
@property (weak, nonatomic) IBOutlet UITableView *repayDetalTableView;
@property (weak, nonatomic) IBOutlet MSFBlurButton *repayMoneyBT;

@property (weak, nonatomic) IBOutlet UILabel *monthDay;
@property (nonatomic, strong) MSFMyRepayDetailViewModel *viewModel;
@property (nonatomic, strong) MSFTableViewBindingHelper *bindingHelper;

@end

@implementation MSFMyRepayDetalViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [[UIStoryboard storyboardWithName:@"MSFMyRepayContainerViewController" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFMyRepayDetalViewController class])];
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"详情信息";
	self.edgesForExtendedLayout = UIRectEdgeNone;
	
	RAC(self, repayMoneyCountLB.text) = RACObserve(self, viewModel.latestDueMoney);
	RAC(self, contractTitle.text) = RACObserve(self, viewModel.contractTitle);
	RAC(self, monthDay.text) = RACObserve(self, viewModel.latestDueDate);
	[self bindTableView];
	self.repayDetalTableView.emptyDataSetSource = self;
	self.repayDetalTableView.emptyDataSetDelegate = self;
	self.repayDetalTableView.allowsSelection = NO;
	self.repayDetalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.repayMoneyBT.rac_command = self.viewModel.executeFetchRepayCommand;
    self.repayBT.rac_command = self.viewModel.executeFetchRepayPlanCommand;
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self bindTableView];
//    [self.viewModel.executeFetchCommand execute:nil];
//}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.viewModel.active = YES;
	self.viewModel.active = NO;
}

#pragma mark private method

- (void)bindTableView {
	
	self.bindingHelper = [[MSFTableViewBindingHelper alloc] initWithTableView:self.repayDetalTableView sourceSignal:[self.viewModel.executeFetchCommand.executionSignals flattenMap:^RACStream *(id value) {
		return value;
	}] selectionCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal empty];
	}] templateCell:[UINib nibWithNibName:NSStringFromClass([MSFMyRepayDetailTableViewCell class]) bundle:nil]];
	self.bindingHelper.delegate = self;
	
}

#pragma mark - ZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
	NSString *title = @"您还没有账单";
	
	return [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
	return [UIImage imageNamed:@"cell-icon-normal.png"];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 61;
}

@end
