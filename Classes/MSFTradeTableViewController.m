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

#import "MSFTrade.h"
#import "MSFClient+Trades.h"

#import "MSFCommandView.h"

#import "MSFUtils.h"

#import "MSFTradeTableViewCell.h"
#import "UITableView+MSFActivityIndicatorViewAdditions.h"
#define SEPARATORCOLOR @"5787c0"
#define CELLBACKGROUNDCOLOR @"dce6f2"
#define TYPEFACECOLOR @"5787c0"

@interface MSFTradeTableViewController ()

@property(nonatomic,strong) NSArray *objects;

@end

@implementation MSFTradeTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"历史交易";
	UIEdgeInsets edgeInset = self.tableView.separatorInset;
	self.tableView.separatorInset = UIEdgeInsetsMake(edgeInset.top, 0, edgeInset.bottom, edgeInset.right);
	self.tableView.allowsSelection = NO;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.separatorColor = [MSFCommandView getColorWithString:SEPARATORCOLOR];
	self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,0.6)];
	[self.tableView.tableHeaderView setBackgroundColor:[MSFCommandView getColorWithString:SEPARATORCOLOR]];
	[self.tableView setEditing:NO];
	
	RACSignal *signal = [[MSFUtils.httpClient fetchTrades].collect replayLazily];
	self.tableView.backgroundView = [self.tableView viewWithSignal:signal message:@"苍茫的天空,一个字都没有"];
	[signal subscribeNext:^(id x) {
		[self setExtraCellLineHidden:self.tableView];
		self.objects = x;
		[self.tableView reloadData];
	}];
}

#pragma mark - 去掉多余分割线

- (void)setExtraCellLineHidden:(UITableView *)tableView {
	
	UIView *view = [UIView new];
	
	view.backgroundColor = [UIColor clearColor];
	
	[tableView setTableFooterView:view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.objects.count;
}

- (MSFTradeTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellID = @"MSFTradeTableViewCell";
	
	MSFTradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"MSFTradeTableViewCell" owner:self options:nil] lastObject];
	}
	
	MSFTrade *trade = [self.objects objectAtIndex:indexPath.row];
	
	[cell.date setTextColor:[MSFCommandView getColorWithString:TYPEFACECOLOR]];
	[cell.tradeDescription setTextColor:[MSFCommandView getColorWithString:TYPEFACECOLOR]];
	[cell.amount setTextColor:[MSFCommandView getColorWithString:TYPEFACECOLOR]];
//	[cell.tradeDescription setFont:[UIFont systemFontOfSize:18]];
//	[cell.date setFont:[UIFont systemFontOfSize:18]];
//	[cell.amount setFont:[UIFont systemFontOfSize:18]];
	
	if (indexPath.row == 0) {
		cell.date.text = @"日期";
		cell.tradeDescription.text = @"交易描述";
		cell.amount.text = @"金额";
		[cell setBackgroundColor:[MSFCommandView getColorWithString:CELLBACKGROUNDCOLOR]];
	}
	else {
		cell.date.text = [NSString stringWithFormat:@"%@",trade.tradeDate];
		cell.tradeDescription.text = [NSString stringWithFormat:@"%@",trade.tradeDescription];
		cell.amount.text = [NSString stringWithFormat:@"%.lf",trade.tradeAmount];
	}

	return cell;
}

@end