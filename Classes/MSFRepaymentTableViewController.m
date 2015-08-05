//
//	MSFReaymentTableViewController.m
//	Cash
//
//	Created by xutian on 15/5/17.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFRepaymentTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>

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
@interface MSFRepaymentTableViewController ()

@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, strong) MSFRepaymentSchedules *rs;

@end

@implementation MSFRepaymentTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"还款计划";
	
	self.tableView.estimatedRowHeight = 44.0f;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	
	UIEdgeInsets edgeInset = self.tableView.separatorInset;
	self.tableView.separatorInset = UIEdgeInsetsMake(edgeInset.top, 0, edgeInset.bottom, edgeInset.right);
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.separatorColor = [MSFCommandView getColorWithString:BLUETCOLOR];
	self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.6)];
	[self.tableView.tableHeaderView setBackgroundColor:[MSFCommandView getColorWithString:BLUETCOLOR]];
	
	RACSignal *signal = [[MSFUtils.httpClient fetchRepaymentSchedules].collect replayLazily];
	self.tableView.backgroundView = [self.tableView viewWithSignal:signal message:@"您还没有还款计划哦......"];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.objects.count;
}

- (MSFRepaymentTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
	
	static NSString *cellID = @"MSFRepaymentTableViewCell";
	
	MSFRepaymentTableViewCell *cell = (MSFRepaymentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
	
	if (cell == nil) {
		cell = [[MSFRepaymentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
																						reuseIdentifier:cellID];
		
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	[cell setBackgroundColor:[MSFCommandView getColorWithString:CELLBACKGROUNDCOLOR]];
	
	_rs = self.objects[indexPath.row];
	
	NSDate *time = [NSDateFormatter msf_dateFromString:_rs.repaymentTime];
	NSDateFormatter *df = [[NSDateFormatter alloc]init];
	df.dateFormat = @"yyyy/MM/dd";
	
	cell.contractNumLabel.text = _rs.contractNum;
	cell.contractStatusLabel.text = _rs.contractStatus;
	cell.shouldAmountLabel.text = [NSString stringWithFormat:@".2%f", _rs.repaymentTotalAmount];
	cell.asOfDateLabel.text = [df stringFromDate:time];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MSFContractDetailsTableViewController *cdTableViewController = [[MSFContractDetailsTableViewController alloc]initWithStyle:UITableViewStylePlain];
	
	cdTableViewController.repayMentSchdues = self.objects[indexPath.row];
	
	[self.navigationController pushViewController:cdTableViewController animated:YES];
}

@end