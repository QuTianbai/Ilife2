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
#import "MSFXBMCustomHeader.h"
#import "MSLoanListTableViewCell.h"

#import "MSFCommandView.h"
#import "MSFCellButton.h"
#import "MSFWebViewController.h"
#import "UITableView+MSFActivityIndicatorViewAdditions.h"
#import "MSFHomePageCellModel.h"

#define ORAGECOLOR @"ff6600"
#define BLUECOLOR @"#0babed"

@interface MSFLoanListViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *dataTableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (strong, nonatomic)  UILabel *money;
@property (strong, nonatomic)  UILabel *months;
@property (strong, nonatomic)  UILabel *time;
@property (strong, nonatomic)  UILabel *check;
@property (nonatomic, weak) MSFHomePageCellModel *viewModel;

@end

@implementation MSFLoanListViewController

- (void)dealloc {
		NSLog(@"MSFLoanListViewController `-dealloc`");
}

- (instancetype)initWithViewModel:(MSFHomePageCellModel *)viewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
	
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = @"申请记录";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	
	self.dataArray = [[NSMutableArray alloc] init];
	self.view.backgroundColor = [UIColor whiteColor];

	[self creatTableView];
	RACSignal *signal = [self.viewModel fetchApplyListSignal];
	self.dataTableView.backgroundView = [self.dataTableView viewWithSignal:signal message:@"亲,您还没有申请记录哟\n赶紧申请吧" AndImage:[UIImage imageNamed:@"icon-empty"]];
	[signal subscribeNext:^(id x) {
		if ([x count] != 0) {
			[self headView];
		}
		self.dataArray = x;
		[self.dataTableView reloadData];
	}];
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)creatTableView {
	self.dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
	self.dataTableView.dataSource = self;
	self.dataTableView.delegate = self;
	self.dataTableView.tableFooterView = [UIView new];
	self.dataTableView.allowsSelection = YES;
	
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
	static NSString *identifier = @"MSLoanListTableViewCell";
	MSLoanListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[MSLoanListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	[cell bindModel:[_dataArray objectAtIndex:indexPath.row]];
	return cell;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
#warning TODO
	return;
	MSFApplyList *listModel = [self.dataArray objectAtIndex:indexPath.row];
	if (listModel.status.integerValue == 4 || listModel.status.integerValue == 6 || listModel.status.integerValue == 7) {
		[[MSFUtils.httpClient fetchRepayURLWithAppliList:listModel] subscribeNext:^(id x) {
			MSFWebViewController *webViewController = [[MSFWebViewController alloc] initWithRequest:x];
			[self.navigationController pushViewController:webViewController animated:YES];
		}];
	}
}*/

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
	
	_money.textAlignment = NSTextAlignmentCenter;
	_months.textAlignment = NSTextAlignmentCenter;
	_time.textAlignment = NSTextAlignmentCenter;
	_check.textAlignment = NSTextAlignmentCenter;
	
	_money.text = @"金额";
	_months.text = @"期数";
	
	_time.text = @"日期";
	_check.text = @"状态";
	
	[superView addSubview:_money];
	[superView addSubview:_months];
	[superView addSubview:_time];
	[superView addSubview:_check];
	
	@weakify(self)
	[_time mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(superView);
		make.left.equalTo(superView);
	}];
	
	[_months mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.centerY.equalTo(superView);
		make.left.equalTo(self.time.mas_right);
	}];
	
	[_money mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.centerY.equalTo(superView);
		make.left.equalTo(self.months.mas_right);
	}];
	
	[_check mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.centerY.equalTo(superView);
		make.left.equalTo(self.money.mas_right);
		make.right.equalTo(superView);
		make.width.equalTo(@[_time, _months, _money]);
	}];
	
}

@end
