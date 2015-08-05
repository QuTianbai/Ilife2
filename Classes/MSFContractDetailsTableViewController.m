//
//	MSFContractDetailsTableViewController.m
//	Cash
//
//	Created by xutian on 15/5/18.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFContractDetailsTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>

#import "MSFRepaymentTableViewController.h"

#import "MSFContractDetailsTableViewCell.h"
#import "MSFPlanPerodicTables.h"

#import "MSFPlanPerodicTables.h"
#import "MSFClient+PlanPerodicTables.h"
#import "MSFUtils.h"

#import "NSDateFormatter+MSFFormattingAdditions.h"

#import "MSFCommandView.h"

#define CELLBACKGROUNDCOLOR @"dce6f2"

@interface MSFContractDetailsTableViewController ()

@property (nonatomic, strong) NSArray *objects;

@end

@implementation MSFContractDetailsTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"还款明细";
	
	self.tableView.estimatedRowHeight = 44.0f;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	
	[[[MSFUtils.httpClient fetchPlanPerodicTables:_repayMentSchdues]
		collect]
	 subscribeNext:^(id x) {
		 self.objects = x;
		 [self.tableView reloadData];
	 }
	 error:^(NSError *error) {
		 
		 NSLog(@"fetchPlanPerodicTablesERROR----%@", error);
	 }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.objects.count;
}

- (MSFContractDetailsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellID = @"MSFContractDetailsTableViewCell";
	
	MSFContractDetailsTableViewCell *cell = (MSFContractDetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
	
	if (cell == nil) {
		
		cell = [[MSFContractDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
	}
	[cell.asOfDateLabel setTextAlignment:NSTextAlignmentCenter];
	[cell.shouldAmountLabel setTextAlignment:NSTextAlignmentCenter];
	[cell.paymentLabel setTextAlignment:NSTextAlignmentCenter];
	[cell.stateLabel setTextAlignment:NSTextAlignmentCenter];
	
	MSFPlanPerodicTables *ppt = self.objects[indexPath.row];
	if (indexPath.row == 0) {
		[cell.asOfDateLabel setText:@"截止日期"];
		[cell.shouldAmountLabel setText:@"应还金额"];
		[cell.paymentLabel setText:@"款项"];
		[cell.stateLabel setText:@"状态"];
		cell.backgroundColor = [MSFCommandView getColorWithString:CELLBACKGROUNDCOLOR];
	} else {
		NSDate *time = [NSDateFormatter msf_dateFromString:ppt.repaymentTime];
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		df.dateFormat = @"yyyy/MM/dd";
		[cell.asOfDateLabel setText:[df stringFromDate:time]];
		[cell.shouldAmountLabel setText:[NSString stringWithFormat:@"%.2f", ppt.repaymentAmount]];
		[cell.paymentLabel setText:ppt.amountType];
		[cell.stateLabel setText:ppt.contractStatus];
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

@end