//
//	MSFLoanListViewController.m
//	Cash
//
//	Created by xbm on 15/5/20.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFLoanListViewController.h"
#import "MSFApplyList.h"
#import "MSFClient+ApplyList.h"
#import "MSFUtils.h"
#import "MSFXBMCustomHeader.h"
#import "MSLoanListTableViewCell.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFCommandView.h"
#import "MSFCellButton.h"
#import "MSFRepayViewController.h"
#import "MSFWebViewController.h"
#import "UITableView+MSFActivityIndicatorViewAdditions.h"

#define ORAGECOLOR @"ff6600"
#define BLUECOLOR @"#0babed"

@interface MSFLoanListViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *dataTableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (strong, nonatomic)  UILabel *money;
@property (strong, nonatomic)  UILabel *months;
@property (strong, nonatomic)  UILabel *time;
@property (strong, nonatomic)  UILabel *check;

@end

@implementation MSFLoanListViewController

- (void)dealloc {
		NSLog(@"MSFLoanListViewController `-dealloc`");
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"申请记录";
	self.dataArray = [[NSMutableArray alloc] init];
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self creatTableView];
	RACSignal *signal = [[MSFUtils.httpClient fetchApplyList].collect replayLazily];
	self.dataTableView.backgroundView = [self.dataTableView viewWithSignal:signal message:@"亲,您还没有申请记录哟\n赶紧申请吧"];
	[signal subscribeNext:^(id x) {
		if ([x count] != 0) {
			[self headView];
		}
		self.dataArray = x;
		[self.dataTableView reloadData];
	}];
}

- (void)creatTableView {
	self.dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
	self.dataTableView.dataSource = self;
	self.dataTableView.delegate = self;
	self.dataTableView.tableFooterView = [UIView new];
	
	[self.view addSubview:self.dataTableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 44;
}

- (MSLoanListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellStr = @"MSLoanListTableVewCell";
	
	MSLoanListTableViewCell *cell = (MSLoanListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellStr];
	
	if (cell == nil) {
		cell = [[MSLoanListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
	}

	MSFApplyList *listModel = [_dataArray objectAtIndex:indexPath.row];
	
	[cell.moneyLabel setTextAlignment:NSTextAlignmentCenter];
	[cell.monthsLabel setTextAlignment:NSTextAlignmentCenter];
	[cell.timeLabel setTextAlignment:NSTextAlignmentCenter];
	
	cell.moneyLabel.text = listModel.total_amount;
	cell.monthsLabel.text = [NSString stringWithFormat:@"%@期", listModel.total_installments];
	
	NSString *df = [NSDateFormatter msf_stringFromDateForDash:listModel.apply_time];
	
	cell.timeLabel.text = df;

	if (listModel.status.integerValue == 4 || listModel.status.integerValue == 6 || listModel.status.integerValue == 7) {
		cell.selectable = YES;
		[cell.checkLabel setTitleColor:[MSFCommandView getColorWithString:ORAGECOLOR] forState:UIControlStateNormal];
	} else {
		cell.selectable = NO;
		[cell.checkLabel setTitleColor:[MSFCommandView getColorWithString:@"#585858"] forState:UIControlStateNormal];
	}
	//[self getStatus:listModel.status.integerValue]
	[cell.checkLabel setTitle:@"预审核通过" forState:UIControlStateNormal];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	MSFApplyList *listModel = [self.dataArray objectAtIndex:indexPath.row];
	if (listModel.status.integerValue == 4 || listModel.status.integerValue == 6 || listModel.status.integerValue == 7) {
		[[MSFUtils.httpClient fetchRepayURLWithAppliList:listModel] subscribeNext:^(id x) {
			MSFWebViewController *webViewController = [[MSFWebViewController alloc] initWithRequest:x];
			[self.navigationController pushViewController:webViewController animated:YES];
		}];
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}

	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (void)viewDidLayoutSubviews {
	if ([self.dataTableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.dataTableView setSeparatorInset:UIEdgeInsetsZero];
	}

	if ([self.dataTableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.dataTableView setLayoutMargins:UIEdgeInsetsZero];
	}
}

#pragma mark - Private

- (NSString *)getStatus:(NSInteger)status {
	//0 1：审核中，2：审核通过，3：审核未通过，4：还款中，5：取消，6：已完结，7：已逾期
	switch (status) {
		case 0:
			return @"审核中";
			break;
		case 1:
			return @"审核中";
			break;
		case 2:
			return @"审核通过";
			break;
		case 3:
			return @"审核未通过";
			break;
		case 4:
			return @"还款中";
			break;
		case 5:
			return @"已取消";
			break;
		case 6:
			return @"已结束";
			break;
		case 7:
			return @"已逾期";
			break;
		case 8:
			return @"预审核通过";
			break;
		case 9:
			return @"待放款";
			break;
		default:
			return @"";
			break;
	}
	
	return @"";
}

- (void)headView {
	_money = [[UILabel alloc] init];
	_months = [[UILabel alloc] init];
	_time = [[UILabel alloc] init];
	_check = [[UILabel alloc] init];
	
	UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
	headView.layer.masksToBounds = YES;
	headView.layer.borderWidth = 0.9;
	headView.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.08] CGColor];
	
	[headView setBackgroundColor:[UIColor clearColor]];
	
	[self.view addSubview:headView];
	
	_dataTableView.tableHeaderView = headView;
	
	UIView *superView = _dataTableView.tableHeaderView;
	
	_money.textColor = [MSFCommandView getColorWithString:BLUECOLOR];
	_months.textColor = [MSFCommandView getColorWithString:BLUECOLOR];
	_time.textColor = [MSFCommandView getColorWithString:BLUECOLOR];
	_check.textColor = [MSFCommandView getColorWithString:BLUECOLOR];
	
	_money.text = @"金额";
	_months.text = @"期数";
	
	_time.text = @"日期";
	_check.text = @"状态";
	
	[superView addSubview:_money];
	[superView addSubview:_months];
	[superView addSubview:_time];
	[superView addSubview:_check];
	
	NSInteger edges = [UIScreen mainScreen].bounds.size.width / 8;
	[_time mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(superView);
		make.centerX.equalTo(superView.mas_left).offset(edges);
		make.height.equalTo(@[_check, _months,_money]);
	}];
	
	[_months mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(superView);
		make.centerX.equalTo(superView.mas_centerX).offset(-edges);
	}];
	
	[_money mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(superView);
		make.centerX.equalTo(superView.mas_centerX).offset(edges);
		
	}];
	
	[_check mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(superView);
		make.centerX.equalTo(superView.mas_right).offset(-edges);
	}];
	
}

@end
