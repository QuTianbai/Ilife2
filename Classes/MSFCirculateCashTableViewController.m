//
//  MSFCirculateCashTableViewController.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCirculateCashTableViewController.h"
#import "MSFLoanLimitView.h"
#import "MSFEdgeButton.h"
#import "MSFCirculateCashViewModel.h"

@interface MSFCirculateCashTableViewController ()
@property (weak, nonatomic) IBOutlet MSFLoanLimitView *loanlimiteView;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *outMoneyBT;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *inputMoneyBT;
@property (weak, nonatomic) IBOutlet UILabel *outTimeMoneyLB;
@property (weak, nonatomic) IBOutlet UILabel *lastInputMoneyLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastInputMoneyTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *countInpoutMoneyLB;
@property (weak, nonatomic) IBOutlet UILabel *deadLineLB;

@property (nonatomic, strong) MSFCirculateCashViewModel *viewModel;

@end

@implementation MSFCirculateCashTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.loanlimiteView setAvailableCredit:@"4000" usedCredit:@"3000"];
	_viewModel = [[MSFCirculateCashViewModel alloc] initWithServices:self.services];
	self.viewModel.active = YES;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

@end
