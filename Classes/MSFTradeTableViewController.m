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

@interface MSFTradeTableViewController ()

@property (nonatomic, strong) NSArray *objects;

@end

@implementation MSFTradeTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"历史交易";
	UIEdgeInsets edgeInset = self.tableView.separatorInset;
	self.tableView.separatorInset = UIEdgeInsetsMake(edgeInset.top, 0, edgeInset.bottom, edgeInset.right);
	self.tableView.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.04];
	self.tableView.allowsSelection = NO;
	[self.tableView setEditing:NO];
	
	RACSignal *signal = [[MSFUtils.httpClient fetchTrades].collect replayLazily];
	self.tableView.backgroundView = [self.tableView viewWithSignal:signal message:@"您还没有历史交易哦......" AndImage:[UIImage imageNamed:@"icon-empty"]];
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
	if (self.objects.count == 0) {
		return 0;
	} else {
		return self.objects.count + 1;
	}
}

- (MSFTradeTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellID = @"MSFTradeTableViewCell";
	
	MSFTradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"MSFTradeTableViewCell" owner:self options:nil] lastObject];
	}
	
	
	
	if (indexPath.row == 0) {
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
		
	} else {
		MSFTrade *trade = [self.objects objectAtIndex:indexPath.row - 1];
		[cell.date setTextColor:[MSFCommandView getColorWithString:BLACKCOLOR]];
		[cell.tradeDescription setTextColor:[MSFCommandView getColorWithString:BLACKCOLOR]];
		[cell.amount setTextColor:[MSFCommandView getColorWithString:BLACKCOLOR]];
		
		[cell.date setFont:[UIFont systemFontOfSize:14]];
		[cell.amount setFont:[UIFont systemFontOfSize:14]];
		[cell.tradeDescription setFont:[UIFont systemFontOfSize:14]];
		cell.date.text = [NSDateFormatter msf_stringFromDateForDash:trade.tradeDate];
		
		cell.tradeDescription.text = [NSString stringWithFormat:@"%@", trade.tradeDescription];
		cell.amount.text = trade.tradeAmount;
		[cell setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.03]];
	}

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

@end