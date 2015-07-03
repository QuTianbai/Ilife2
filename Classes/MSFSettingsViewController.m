//
// MSFSettingsViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSettingsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>

#import "MSFCommandView.h"

#import "MSFAboutUsCell.h"
#import "MSFProductIntroductionCell.h"
#import "MSFUserHelpCell.h"
#import "MSFBranchesCell.h"

#import "MSFSettingTableViewCell.h"

#define SEPARATORCOLOR @"5787c0"
#define CELLBACKGROUNDCOLOR @"dce6f2"
#define TYPEFACECOLOR @"5787c0"

@implementation MSFSettingsViewController
{
  NSArray *_imageArray;
  NSArray *_textArray;
}

#pragma mark - Lifecycle

- (instancetype)init {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MSFSettingsViewController" bundle:nil];
  self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
  if (!self) {
    
    return nil;
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"设置";
  
  _imageArray = [[NSArray alloc] initWithObjects:@"iconfont-guanyuwomen.png",@"iconfont-chanpinjieshao.png",@"iconfont-bangzhu.png",@"iconfont-wangdian.png", nil];
  
  _textArray = [[NSArray alloc] initWithObjects:@"关于我们",@"产品介绍",@"用户帮助",@"网点分布", nil];
  
  UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"left_arrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBackBtn)];
  
  self.navigationItem.leftBarButtonItem = leftBtn;
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  UIEdgeInsets edgeInset = self.tableView.separatorInset;
  self.tableView.separatorInset = UIEdgeInsetsMake(edgeInset.top, 0, edgeInset.bottom, edgeInset.right);
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  
  [self.tableView setScrollEnabled:NO];
  [self setExtraCellLineHidden:self.tableView];
}

#pragma mark - 去掉多余分割线

- (void)setExtraCellLineHidden:(UITableView *)tableView {
  
  UIView *view = [UIView new];
  
  view.backgroundColor = [UIColor clearColor];
  
  [tableView setTableFooterView:view];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (MSFSettingTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"cellID";
  
  MSFSettingTableViewCell *cell = (MSFSettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
  
  if (cell == nil) {
    
    cell = [[MSFSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
  }
  [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  cell.text_label.text = [_textArray objectAtIndex:indexPath.row];
  cell.picImageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case 0:
      [self performSegueWithIdentifier:@"aboutCell" sender:self];
      break;
    case 1:
      [self performSegueWithIdentifier:@"productCell" sender:self];
      break;
    case 2:
      [self performSegueWithIdentifier:@"userHelpCell" sender:self];
      break;
    case 3:
      [self performSegueWithIdentifier:@"branchCell" sender:self];
      break;
    default:
      break;
  }
}

#pragma mark - onClickBackBtn

- (void)onClickBackBtn {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

@end