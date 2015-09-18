//
//	MSFTradeTableViewController.m
//	Cash
//
//	Created by xutian on 15/5/17.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFTradeTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFTrade.h"
#import "MSFClient+Trades.h"
#import "MSFCommandView.h"
#import "MSFUtils.h"
#import "MSFTradeTableViewCell.h"
#import "UITableView+MSFActivityIndicatorViewAdditions.h"
#define BLUETCOLOR @"0babed"
#define BLACKCOLOR @"#585858"
#import "MSFTableViewBindingHelper.h"
#import "MSFTradeViewModel.h"

@interface MSFTradeTableViewController ()

@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, strong) MSFTableViewBindingHelper *bindingHelper;

@end

@implementation MSFTradeTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"历史交易";
	
	RACSignal *signal = [[[[MSFUtils.httpClient fetchTrades] map:^id(id value) {
		return [[MSFTradeViewModel alloc] initWithModel:value];
	}]
	collect]
	replayLazily];
	
	self.tableView.allowsSelection = NO;
	self.tableView.tableFooterView = [UIView new];
	self.tableView.backgroundView = [self.tableView viewWithSignal:signal message:@"您还没有历史交易哦......" AndImage:[UIImage imageNamed:@"icon-empty"]];
	self.bindingHelper = [MSFTableViewBindingHelper bindingHelperForTableView:self.tableView sourceSignal:signal selectionCommand:nil templateCell:[UINib nibWithNibName:@"MSFTradeTableViewCell" bundle:nil]];
	self.bindingHelper.delegate = self;
	
	[signal subscribeNext:^(id x) {
		if ([x count] == 0) {
			self.tableView.tableHeaderView = nil;
			return;
		}
		self.tableView.tableHeaderView = self.tableHeaderView;
	}];
}

- (UIView *)tableHeaderView {
	static MSFTradeTableViewCell *cell;
	if (cell) return cell;
	cell = [[[NSBundle mainBundle] loadNibNamed:@"MSFTradeTableViewCell" owner:self options:nil] lastObject];
	[cell.date setTextColor:[MSFCommandView getColorWithString:BLUETCOLOR]];
	[cell.tradeDescription setTextColor:[MSFCommandView getColorWithString:BLUETCOLOR]];
	[cell.amount setTextColor:[MSFCommandView getColorWithString:BLUETCOLOR]];
	[cell.date setFont:[UIFont systemFontOfSize:15]];
	[cell.amount setFont:[UIFont systemFontOfSize:15]];
	[cell.tradeDescription setFont:[UIFont systemFontOfSize:15]];
	cell.date.text = @"日期";
	cell.tradeDescription.text = @"交易描述";
	cell.amount.text = @"金额";
	[cell setBackgroundColor:[UIColor whiteColor]];
	return cell;
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

@end