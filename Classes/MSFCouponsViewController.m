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

@end
