//
//	MSFReaymentTableViewController.m
//	Cash
//
//	Created by xutian on 15/5/17.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFRepaymentTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFRepaymentSchedules.h"
#import "MSFClient+RepaymentSchedules.h"
#import "MSFUtils.h"
#import "MSFRepaymentTableViewCell.h"
#import "MSFContractDetailsTableViewController.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "UITableView+MSFActivityIndicatorViewAdditions.h"
#import "MSFCommandView.h"

#define CELLBACKGROUNDCOLOR @"dce6f2"
#define BLUETCOLOR @"0babed"
#import "MSFTableViewBindingHelper.h"
#import "MSFRepaymentSchedulesViewModel.h"

@interface MSFRepaymentTableViewController ()

@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, strong) MSFRepaymentSchedules *rs;
@property (nonatomic, strong) MSFTableViewBindingHelper *bindingHelper;

@end

@implementation MSFRepaymentTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"还款计划";
	RACSignal *signal = [[[[MSFUtils.httpClient fetchRepaymentSchedules] map:^id(id value) {
		return [[MSFRepaymentSchedulesViewModel alloc] initWithModel:value];
	}]
	collect]
	replayLazily];
	self.tableView.separatorColor = [MSFCommandView getColorWithString:BLUETCOLOR];
	self.tableView.backgroundView = [self.tableView viewWithSignal:signal message:@"您还没有还款计划哦......" AndImage:[UIImage imageNamed:@"icon-empty"]];
	RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(MSFRepaymentSchedulesViewModel *input) {
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			MSFContractDetailsTableViewController *cdTableViewController = [[MSFContractDetailsTableViewController alloc]initWithStyle:UITableViewStylePlain];
			cdTableViewController.repayMentSchdues = input.model;
			[self.navigationController pushViewController:cdTableViewController animated:YES];
			[subscriber sendCompleted];
			return nil;
		}];
	}];
	self.tableView.tableFooterView = UIView.new;
	self.bindingHelper = [[MSFTableViewBindingHelper alloc] initWithTableView:self.tableView sourceSignal:signal selectionCommand:command registerClass:MSFRepaymentTableViewCell.class];
	self.bindingHelper.delegate = self;
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
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.tableView setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end