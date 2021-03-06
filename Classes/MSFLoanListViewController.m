//
//	MSFLoanListViewController.m
//	Cash
//
//	Created by xbm on 15/5/20.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFLoanListViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFApplyList.h"
#import "MSFClient+ApplyList.h"
#import "UIColor+Utils.h"
#import "MSLoanListTableViewCell.h"
#import "UITableView+MSFActivityIndicatorViewAdditions.h"
#import "MSFApplyListViewModel.h"
#import "MSFPlanListSegmentBar.h"

@interface MSFApplyListHeader : UIView

@property (nonatomic, strong) UILabel *money;
@property (nonatomic, strong) UILabel *months;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *check;

- (void)msApply;
- (void)mlApply;

@end

@implementation MSFApplyListHeader

- (void)dealloc {
	NSLog(@"MSFApplyListHeader : dealloc");
}

- (instancetype)init {
	self = [super init];
	if (self) {
		self.layer.masksToBounds = YES;
		self.backgroundColor = UIColor.clearColor;
		
		UILabel *money  = [[UILabel alloc] init];
		UILabel *months = [[UILabel alloc] init];
		UILabel *time   = [[UILabel alloc] init];
		UILabel *check  = [[UILabel alloc] init];
		money.textColor  = UIColor.themeColorNew;
		months.textColor = UIColor.themeColorNew;
		time.textColor   = UIColor.themeColorNew;
		check.textColor  = UIColor.themeColorNew;
		money.textAlignment  = NSTextAlignmentCenter;
		months.textAlignment = NSTextAlignmentCenter;
		time.textAlignment   = NSTextAlignmentCenter;
		check.textAlignment  = NSTextAlignmentCenter;
		money.text  = @"金额";
		months.text = @"期数";
		time.text   = @"日期";
		check.text  = @"状态";
		[self addSubview:money];
		[self addSubview:months];
		[self addSubview:time];
		[self addSubview:check];
		
		[time mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self);
		}];
		[months mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(time.mas_right);
		}];
		[money mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(months.mas_right);
		}];
		[check mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(money.mas_right);
			make.right.equalTo(self);
			make.width.equalTo(@[time, months, money]);
		}];
		
		_money = money;
		_months = months;
		_time = time;
		_check = check;
	}
	return self;
}

- (void)msApply {
	[self addSubview:_money];
	[self addSubview:_months];
	[_time mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.left.equalTo(self);
	}];
	[_months mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.left.equalTo(self.time.mas_right);
	}];
	[_money mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.left.equalTo(self.months.mas_right);
	}];
	[_check mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.left.equalTo(self.money.mas_right);
		make.right.equalTo(self);
		make.width.equalTo(@[self.time, self.months, self.money]);
	}];
}

- (void)mlApply {
	[_money removeFromSuperview];
	[_months removeFromSuperview];
	[_time mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.left.equalTo(self);
	}];
	[_check mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.left.equalTo(self.time.mas_right);
		make.right.equalTo(self);
		make.width.equalTo(self.time);
	}];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, 0, rect.size.height);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
	CGContextSetLineWidth(context, 1);
	CGContextSetStrokeColorWithColor(context, UIColor.borderColor.CGColor);
	CGContextStrokePath(context);
}

@end

@interface MSFLoanListViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *dataTableView;
@property (nonatomic, strong) MSFApplyListHeader *headView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) MSFApplyListViewModel *viewModel;

@end

@implementation MSFLoanListViewController

- (void)dealloc {
		NSLog(@"MSFLoanListViewController `-dealloc`");
}

- (instancetype)initWithViewModel:(MSFApplyListViewModel *)viewModel {
  self = [super init];
  if (self) {
		self.hidesBottomBarWhenPushed = YES;
		_viewModel = viewModel;
	}
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = @"申请记录";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.dataArray = [[NSMutableArray alloc] init];
	self.view.backgroundColor = [UIColor whiteColor];
	[self setUpViews];
}

- (void)loadData {
	self.headView.hidden = YES;
	self.dataArray = nil;
	[self.dataTableView reloadData];
	RACSignal *signal = [self.viewModel fetchApplyListSignal];
	self.dataTableView.backgroundView = [self.dataTableView viewWithSignal:signal message:@"亲,您还没有申请记录哟\n赶紧申请吧" AndImage:[UIImage imageNamed:@"icon-empty"]];
	[signal subscribeNext:^(id x) {
		self.dataArray = x;
		[self.dataTableView reloadData];
		self.headView.hidden = [x count] == 0;
		if (self.dataArray.count > 0) {
			MSFApplyList *model = self.dataArray[0];
			if (model.loanTerm) {
				[_headView msApply];
			} else {
				[_headView mlApply];
			}
		}
	}];
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
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
	
	MSFApplyList *obj = self.dataArray[indexPath.row];
	if (obj.loanTerm) {
		[cell bindModel:[_dataArray objectAtIndex:indexPath.row] type:0];
	} else {
		[cell bindModel:[_dataArray objectAtIndex:indexPath.row] type:1];
	}
	
	return cell;
}

#pragma mark - Private

- (void)setUpViews {
	MSFPlanListSegmentBar *bar = [[MSFPlanListSegmentBar alloc] initWithTitles:@[@"分期", @"随借随还"]];
	[self.view addSubview:bar];
	CGFloat baseLine = 0;
	if (self.navigationController.navigationBar.translucent) {
		baseLine = self.navigationController.navigationBar.frame.size.height + 20.f;
	}
	[bar mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(@(baseLine));
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.height.equalTo(@0);
	}];
	
	_headView = [[MSFApplyListHeader alloc] init];
	_headView.hidden = YES;
	[self.view addSubview:_headView];
	[_headView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view);
		make.top.equalTo(bar.mas_bottom);
		make.right.equalTo(self.view);
		make.height.equalTo(@40);
	}];
	
	_dataTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	_dataTableView.dataSource = self;
	_dataTableView.delegate = self;
	_dataTableView.tableFooterView = [UIView new];
	_dataTableView.allowsSelection = NO;
	[self.view addSubview:_dataTableView];
	[_dataTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.top.equalTo(_headView.mas_bottom);
		make.bottom.equalTo(self.view);
	}];
	[self loadData];
}

@end
