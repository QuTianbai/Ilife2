//
//  MSFRepaymentPlanViewController.m
//  Finance
//
//  Created by xbm on 15/11/18.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFRepaymentPlanViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFTableViewBindingHelper.h"
#import "MSFRepaymentTableViewCell.h"
#import "MSFCirculateRepaymentTableViewCell.h"
#import "MSFRepaymentSchedulesViewModel.h"
#import "UITableView+MSFActivityIndicatorViewAdditions.h"
#import "MSFContractDetailsTableViewController.h"
#import "MSFRepaymentViewModel.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFRepaymentPlanViewController ()<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *leftBarButton;
@property (weak, nonatomic) IBOutlet UIButton *rightBarButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leaderConstraint;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITableView *circulateRepayMentTableView;
@property (nonatomic, strong) MSFTableViewBindingHelper *bindingHelper;
@property (nonatomic, strong) MSFRepaymentViewModel *viewModel;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MSFRepaymentPlanViewController

- (instancetype)initWithViewModel:(MSFRepaymentViewModel *)viewModel {
	self = [UIStoryboard storyboardWithName:@"MSFRepaymentPlanStoryboard" bundle:nil].instantiateInitialViewController;
	if (self == nil) {
		return nil;
	}
	_viewModel = viewModel;
	_dataArray = [[NSArray alloc] init];
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"还款计划";
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.width.constant = CGRectGetWidth([UIScreen mainScreen].bounds) / 2;
	[SVProgressHUD showWithStatus:@"正在加载..."];
	RACSignal *signal = [[[[self.viewModel fetchRepaymentSchedulesSignal]
		map:^id(id value) {
			return [[MSFRepaymentSchedulesViewModel alloc] initWithModel:value services:self.viewModel.services];
		}]
		collect]
		replayLazily];
	[signal subscribeNext:^(id x) {
		self.dataArray = x;
		[SVProgressHUD dismiss];
	} error:^(NSError *error) {
		[SVProgressHUD dismiss];
	}];
	self.myTableView.backgroundView = [self.myTableView viewWithSignal:signal message:@"您还没有还款计划哦......" AndImage:[UIImage imageNamed:@"icon-empty"]];
	
	self.circulateRepayMentTableView.hidden = YES;
	
	@weakify(self)
	[[self.leftBarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.circulateRepayMentTableView.hidden = YES;
		self.myTableView.hidden = NO;
		self.myTableView.backgroundView = [self.myTableView viewWithSignal:signal message:@"您还没有还款计划哦......" AndImage:[UIImage imageNamed:@"icon-empty"]];

		[SVProgressHUD showWithStatus:@"正在加载..."];
		RACSignal *signal = [[[[self.viewModel fetchRepaymentSchedulesSignal]
			map:^id(id value) {
				return [[MSFRepaymentSchedulesViewModel alloc] initWithModel:value services:self.viewModel.services];
			}]
			collect]
			replayLazily];
		[signal subscribeNext:^(NSArray *x) {
			if (x.count != 0) {
				self.myTableView.backgroundView.hidden = YES;
				self.dataArray = x;
			}
			[SVProgressHUD dismiss];
		} error:^(NSError *error) {
			[SVProgressHUD dismiss];
		}];
		self.bindingHelper = [[MSFTableViewBindingHelper alloc] initWithTableView:self.myTableView sourceSignal:signal selectionCommand:nil registerClass:MSFRepaymentTableViewCell.class];
		self.bindingHelper.delegate = self;
		[self updateIndicatorViewWithButton:self.leftBarButton];
	}];
	
	[[self.rightBarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.myTableView.hidden = YES;
		self.circulateRepayMentTableView.hidden = NO;
		self.circulateRepayMentTableView.backgroundView = [self.circulateRepayMentTableView viewWithSignal:signal message:@"您还没有还款计划哦......" AndImage:[UIImage imageNamed:@"icon-empty"]];
		[SVProgressHUD showWithStatus:@"正在加载..."];
		RACSignal *signal = [[[[self.viewModel fetchCircleRepaymentSchrdulesSignal] map:^id(id value) {
			return [[MSFRepaymentSchedulesViewModel alloc] initWithModel:value services:self.viewModel.services];
		}]
		collect] replayLazily];
		[signal subscribeNext:^(NSArray *x) {
			if (x.count != 0) {
				self.circulateRepayMentTableView.backgroundView.hidden = YES;
			}
			[SVProgressHUD dismiss];
		} error:^(NSError *error) {
			[SVProgressHUD dismiss];
		}];
		self.bindingHelper = [[MSFTableViewBindingHelper alloc] initWithTableView:self.circulateRepayMentTableView sourceSignal:signal selectionCommand:nil registerClass:MSFCirculateRepaymentTableViewCell.class];
		self.bindingHelper.delegate = self;
		[self updateIndicatorViewWithButton:self.rightBarButton];
	}];
	self.myTableView.tableFooterView = UIView.new;
	self.circulateRepayMentTableView.tableFooterView = UIView.new;
	self.bindingHelper = [[MSFTableViewBindingHelper alloc] initWithTableView:self.myTableView sourceSignal:signal selectionCommand:nil registerClass:MSFRepaymentTableViewCell.class];
	self.bindingHelper.delegate = self;
	[[self rac_signalForSelector:@selector(viewWillDisappear:)]
	 subscribeNext:^(id x) {
		 [SVProgressHUD dismiss];
	 }];
}

- (void)updateIndicatorViewWithButton:(UIButton *)button {
	self.leaderConstraint.constant = [button isEqual:self.leftBarButton] ? 0 : CGRectGetWidth([UIScreen mainScreen].bounds) / 2;
	[UIView animateWithDuration:.3 animations:^{
		[self.segmentView layoutIfNeeded];
	}];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (void)viewDidLayoutSubviews {
	if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.myTableView setSeparatorInset:UIEdgeInsetsZero];
	}
	if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.myTableView setLayoutMargins:UIEdgeInsetsZero];
	}
	
	if ([self.circulateRepayMentTableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.circulateRepayMentTableView setSeparatorInset:UIEdgeInsetsZero];
	}
	if ([self.circulateRepayMentTableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.circulateRepayMentTableView setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == self.circulateRepayMentTableView) {
		return 200;
	}
	NSLog(@"%d", indexPath.row);
	if (self.dataArray.count != 0) {
		MSFRepaymentSchedulesViewModel *viewModel = self.dataArray[indexPath.row];
		if ([viewModel.status isEqualToString:@"已逾期"]) {
			return 121 + 75;
		}
	}
	
	return 121;
}

@end
