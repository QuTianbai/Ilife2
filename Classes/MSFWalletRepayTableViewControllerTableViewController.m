//
//  MSFWalletRepayTableViewControllerTableViewController.m
//  Finance
//
//  Created by Wyc on 16/3/17.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFWalletRepayTableViewControllerTableViewController.h"
#import "MSFWalletRepayTableViewCell.h"
#import "MSFWalletRepayViewModel.h"
#import "MSFWalletViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "MSFTabBarViewModel.h"
#import "MSFCommandView.h"

@interface MSFWalletRepayTableViewControllerTableViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) MSFWalletRepayViewModel *viewModel;

@end

@implementation MSFWalletRepayTableViewControllerTableViewController

- (instancetype)initWithViewModel:(id)viewModel {
    self = [super init];
    if (!self) {
        return nil;
    }
    _viewModel = viewModel;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [MSFCommandView getColorWithString:@"#F6F6F6"];
    self.title = @"支持银行卡";
    self.dataArray = [[NSArray alloc]init];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    MSFWalletRepayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID ];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSFWalletRepayTableViewCell" owner:nil options:nil]firstObject ];
    
    }
   tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MSFRepayPlayMode *model = self.dataArray[indexPath.row];
    cell.loanTerm.text = [NSString stringWithFormat:@"%d期", model.loanTerm];
    cell.lastDueDate.text = [NSString stringWithFormat:@"%@%@", model.latestDueDate,model.contractStatus];
    cell.lastestDueMoney.text = [NSString stringWithFormat:@"¥%.2f", model.latestDueMoney];
    
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPathr {
    return 44;
}

@end
