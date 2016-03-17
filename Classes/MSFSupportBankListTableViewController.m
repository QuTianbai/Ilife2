//
//  MSFSupportBankListTableViewController.m
//  Finance
//
//  Created by Wyc on 16/3/15.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFSupportBankListTableViewController.h"
#import "MSFSupportBankListModel.h"
#import "MSFSupportBankListTableViewCell.h"
#import "MSFCommandView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFClient+BankCardList.h"
#import "MSFSupportBankModel.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFGetBankIcon.h"
#import "MSFTabBarViewModel.h"

@interface MSFSupportBankListTableViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) MSFSupportBankListModel *viewModel;

@end

@implementation MSFSupportBankListTableViewController

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
    
    @weakify(self)
    RACSignal *signal = [[self.viewModel fetchSupportBankSignal].collect replayLazily];
    [signal subscribeNext:^(id x) {
        @strongify(self)
        [SVProgressHUD dismiss];
        for (NSObject *ob in x) {
            if ([ob isEqual:[NSNull null]]) {
                return ;
            }
        }
        self.dataArray = x;
        [self.tableView reloadData];
    }error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
    }];
    
    [[self rac_signalForSelector:@selector(viewWillAppear:)]
     subscribeNext:^(id x) {
         @strongify(self)
         RACSignal *signal = [[self.viewModel fetchSupportBankSignal].collect replayLazily];
         [signal subscribeNext:^(id x) {
             [SVProgressHUD dismiss];
             for (NSObject *ob in x) {
                 if ([ob isEqual:[NSNull null]]) {
                     return ;
                 }
             }
             self.dataArray = x;
             [self.tableView reloadData];
         }error:^(NSError *error) {
             [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
         }];
     }];


    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self)
        
        RACSignal *signal = [[self.viewModel fetchSupportBankSignal].collect replayLazily];
        [signal subscribeNext:^(id x) {
            [SVProgressHUD dismiss];
            for (NSObject *ob in x) {
                if ([ob isEqual:[NSNull null]]) {
                    return ;
                }
            }
            self.dataArray = x;
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        }error:^(NSError *error) {
            [self.tableView.pullToRefreshView stopAnimating];
            [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
        }];
    }];

    
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
    MSFSupportBankListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID ];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MSFSupportBankListTableViewCell" owner:nil options:nil]firstObject];;
    }
    MSFSupportBankModel *model = self.dataArray[indexPath.row];
    cell.BankpicImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [MSFGetBankIcon getIconNameWithBankCode:model.bankCode ]]];
    cell.BankName.text = model.bankName;
    cell.singleAmountLimit.text = [NSString stringWithFormat:@"单笔限额:%.0f", model.singleAmountLimit];
    cell.dayAmountLimit.text = [NSString stringWithFormat:@"单日限额:%.0f", model.dayAmountLimit];
    
    
    return cell;
}

#pragma mark - Navigation

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

@end
