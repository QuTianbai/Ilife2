//
// MSFUserViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUserViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import <libextobjc/extobjc.h>
#import "MSFRepaymentTableViewController.h"
#import "MSFTradeTableViewController.h"
#import "MSFEditPasswordViewController.h"
#import "MSFUserInfoViewController.h"
#import "MSFUtils.h"
#import "MSFClient.h"
#import "MSFUser.h"
#import "MSFClient+Users.h"
#import "MSFLoanListViewController.h"
#import "UIButton+BottomTitles.h"
#import "UIColor+Utils.h"

@interface MSFUserViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSArray *rowTitles;
@property(nonatomic,strong) NSArray *icons;

@end

@implementation MSFUserViewController

#pragma mark - Lifecycle

- (void)loadView {
  self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.tableHeaderView = self.tableViewHeader;
  self.tableView.backgroundColor = [UIColor darkBackgroundColor];
  
  self.rowTitles = @[
    @"申请记录",
    @"还款计划",
    @"历史交易",
    @"修改密码",
    ];
  self.icons = @[
    [UIImage imageNamed:@"icon-account-apply"],
    [UIImage imageNamed:@"icon-account-repay"],
    [UIImage imageNamed:@"icon-account-history"],
    [UIImage imageNamed:@"icon-account-edit"],
  ];
}

#pragma mark - Private

- (UIView *)tableViewHeader {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 170)];
  view.backgroundColor = [UIColor whiteColor];
  
  UIImageView *backgroundView = UIImageView.new;
  backgroundView.image = [UIImage imageNamed:@"bg-account-header"];
  [view addSubview:backgroundView];
  [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(view);
  }];
  
  UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [avatarButton setBackgroundImage:[UIImage imageNamed:@"icon-avatar-placeholder"] forState:UIControlStateNormal];
  [view addSubview:avatarButton];
  [avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@75);
    make.width.equalTo(@75);
    make.center.equalTo(view);
  }];
  
  UILabel *label = UILabel.new;
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor whiteColor];
  label.text = [MSFUtils.httpClient user].name;
  label.hidden = YES;
  [view addSubview:label];
  [label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(avatarButton.mas_bottom).offset(-10);
    make.centerX.equalTo(avatarButton);
  }];
  
  @weakify(self)
  [[avatarButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
      @strongify(self)
      MSFUserInfoViewController *userinfoViewController = [[MSFUserInfoViewController alloc] init];
      userinfoViewController.hidesBottomBarWhenPushed = YES;
      [self.navigationController pushViewController:userinfoViewController animated:YES];
  }];
 
  return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  cell.textLabel.text  = self.rowTitles[indexPath.row];
  cell.imageView.image = self.icons[indexPath.row];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  switch (indexPath.row) {
    case 0:
      [self appliyStatusList:nil];
      break;
    case 1:
      [self repayMentPlan:nil];
      break;
    case 2:
      [self historyDetails:nil];
      break;
    case 3:
      [self editUserInfo:nil];
      break;
    default:
      break;
  }
}

#pragma mark - IBActions

- (IBAction)repayMentPlan:(id)sender {
  MSFRepaymentTableViewController *repaymentVC = [[MSFRepaymentTableViewController alloc]initWithStyle:UITableViewStylePlain];
  repaymentVC.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:repaymentVC animated:YES];
}

- (IBAction)historyDetails:(id)sender {
  MSFTradeTableViewController *tradeVC = [[MSFTradeTableViewController alloc]initWithStyle:UITableViewStylePlain];
  tradeVC.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:tradeVC animated:YES];
}

- (IBAction)editUserInfo:(id)sender {
  MSFEditPasswordViewController *editUserinfoViewController = [[MSFEditPasswordViewController alloc] init];
  editUserinfoViewController.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:editUserinfoViewController animated:YES];
}

- (IBAction)appliyStatusList:(id)sender {
  MSFLoanListViewController *loanListVC = [[MSFLoanListViewController alloc] init];
  loanListVC.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:loanListVC animated:YES];
}

@end
