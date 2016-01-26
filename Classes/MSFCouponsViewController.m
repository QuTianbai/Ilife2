//
// MSFCouponsViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCouponsViewController.h"
#import "MSFCouponsViewModel.h"
#import "MSFTableViewBindingHelper.h"
#import "MSFCouponTableViewCell.h"

@interface MSFCouponsViewController ()

@property (nonatomic, strong) MSFCouponsViewModel *viewModel;
@property (nonatomic, strong) MSFTableViewBindingHelper *bindingHelper;

@end

@implementation MSFCouponsViewController

- (instancetype)initWithViewModel:(id)viewModel {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"我的优惠券";
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
	self.tableView.allowsSelection = NO;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	// B:领取未使用 C:已使用 D:已失效
	[self.viewModel.executeFetchCommand execute:@"B"];
	
	UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	tableHeaderView.backgroundColor = [UIColor clearColor];
	self.tableView.tableHeaderView = tableHeaderView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 126;
}

@end
