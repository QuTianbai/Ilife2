//
// MSFCouponsViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCouponsViewController.h"
#import "MSFCouponsViewModel.h"
#import "MSFTableViewBindingHelper.h"
#import "MSFCouponTableViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface MSFCouponsViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) MSFCouponsViewModel *viewModel;
@property (nonatomic, strong) MSFTableViewBindingHelper *bindingHelper;

@end

@implementation MSFCouponsViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(id)viewModel {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (!self) {
    return nil;
  }
	[self bindViewModel:viewModel];
  
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.allowsSelection = NO;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	tableHeaderView.backgroundColor = [UIColor clearColor];
	self.tableView.tableHeaderView = tableHeaderView;
	self.tableView.emptyDataSetSource = self;
	self.tableView.emptyDataSetDelegate = self;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 126;
}

#pragma MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
	self.bindingHelper = [[MSFTableViewBindingHelper alloc]
		initWithTableView:self.tableView
		sourceSignal:[self.viewModel.executeFetchCommand.executionSignals flattenMap:^RACStream *(id value) {
			return value;
		}]
		selectionCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			return [RACSignal empty];
		}]
		templateCell:[UINib nibWithNibName:NSStringFromClass([MSFCouponTableViewCell class]) bundle:nil]];
	self.bindingHelper.delegate = self;
}

#pragma mark - ZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
	NSString *title = @"";
	if ([self.viewModel.identifer isEqualToString:@"B"]) {
		title = @"你还没有未使用的过优惠券";
	} else if ([self.viewModel.identifer isEqualToString:@"C"]) {
		title = @"你还没有已使用过的优惠券";
	} else if ([self.viewModel.identifer isEqualToString:@"D"]) {
		title = @"你还没有已过期的优惠券";
	}
	return [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
	NSString *subtitle = @"";
	if ([self.viewModel.identifer isEqualToString:@"B"]) {
		subtitle = @"你可以多多关注马上金融活动，惊喜连连！~";
	}
	return [[NSAttributedString alloc] initWithString:subtitle attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
	return [UIImage imageNamed:@"cell-icon-normal.png"];
}

@end
