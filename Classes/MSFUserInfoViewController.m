//
// MSFUserInfoViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUserInfoViewController.h"
#import "MSFUserInfoTableViewCell.h"
#import "MSFClient.h"
#import "MSFUtils.h"
#import "MSFEdgeButton.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFClozeViewController.h"
#import "UIColor+Utils.h"
#import "MSFClient+Users.h"
#import "MSFUser.h"
#import "MSFUserViewModel.h"
#import <CZPhotoPickerController/CZPhotoPickerController.h>

@interface MSFUserInfoViewController ()

@property(nonatomic,strong) NSArray *rowTitles;
@property(nonatomic,strong) NSArray *rowSubtitles;
@property(nonatomic,strong) MSFUserViewModel *viewModel;
@property(nonatomic,strong) CZPhotoPickerController *photoPickerController;

@end

@implementation MSFUserInfoViewController

#pragma mark - Lifecycle

- (void)dealloc {
  NSLog(@"MSFUserInfoViewController -`dealloc`");
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
  if (!(self = [super initWithStyle:UITableViewStyleGrouped])) {
    return nil;
  }
  _viewModel = [[MSFUserViewModel alloc] initWithClient:MSFUtils.httpClient];
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"个人信息";
  self.rowTitles = @[@"姓名",@"身份证号",@"联系方式"];
  [self.tableView registerClass:MSFUserInfoTableViewCell.class forCellReuseIdentifier:@"Cell"];
  self.tableView.tableFooterView = self.tableViewFooter;
  self.tableView.tableHeaderView = self.tableViewHeader;
  self.tableView.backgroundColor = [UIColor whiteColor];
  
  @weakify(self)
  [self.viewModel.contentUpdateSignal subscribeNext:^(id x) {
    @strongify(self)
    self.rowSubtitles = @[
      self.viewModel.username,
      self.viewModel.identifyCard,
      self.viewModel.mobile,
      ];
    [self.tableView reloadData];
    if (self.viewModel.identifyCard.length == 0) {
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
      MSFClozeViewController *clozeViewController =
      [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(MSFClozeViewController.class)];
      UINavigationController *navigationController =
      [[UINavigationController alloc] initWithRootViewController:clozeViewController];
      [self presentViewController:navigationController animated:YES completion:nil];
    }
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.viewModel.active = YES;
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
  
  UIView *avatarView = UIView.new;
  avatarView.layer.borderColor = UIColor.themeColor.CGColor;
  avatarView.layer.borderWidth = 2;
  avatarView.hidden = YES;
  [view addSubview:avatarView];
  UIButton *imageView = [UIButton buttonWithType:UIButtonTypeCustom];
  [imageView setBackgroundImage:[UIImage imageNamed:@"icon-avatar-placeholder"] forState:UIControlStateNormal];
  [view addSubview:imageView];
  [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@120);
    make.width.equalTo(@120);
    make.center.equalTo(view);
  }];
  [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    make.top.equalTo(imageView.mas_bottom).offset(-10);
    make.centerX.equalTo(imageView);
  }];
  
  [[avatarView rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(id x) {
    avatarView.layer.cornerRadius = CGRectGetWidth(avatarView.bounds)/2.0;
    avatarView.layer.masksToBounds = YES;
  }];
  
  [[imageView rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(id x) {
    imageView.layer.cornerRadius = CGRectGetWidth(imageView.bounds)/2.0;
    imageView.layer.masksToBounds = YES;
  }];
  
  @weakify(self)
  [[imageView rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
     @strongify(self)
     self.photoPickerController = [[CZPhotoPickerController alloc] initWithPresentingViewController:self
      withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
        [self.photoPickerController dismissAnimated:YES];
        UIImage *image = imageInfoDict[UIImagePickerControllerEditedImage];
        if (!image) {
          return ;
        }
        [imageView setImage:image forState:UIControlStateNormal];
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        NSString *file = [[@([[NSDate date] timeIntervalSince1970]) stringValue] stringByAppendingString:@".jpg"];
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:file];
        [data writeToFile:path atomically:YES];
        [[MSFUtils.httpClient updateUserAvatarWithFileURL:[NSURL fileURLWithPath:path]]
         subscribeNext:^(MSFUser *user) {
           [MSFUtils.httpClient.user mergeValuesForKeysFromModel:user];
					 [SVProgressHUD showSuccessWithStatus:@"上传成功..."];
         }
         error:^(NSError *error) {
					 [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
         }];
     }];
     [self.photoPickerController showFromRect:CGRectZero];
   }];
 
  return view;
}

- (UIView *)tableViewFooter {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 50)];
  view.backgroundColor = [UIColor whiteColor];
  MSFEdgeButton *button = MSFEdgeButton.new;
  [button setTitleColor:UIColor.themeColor forState:UIControlStateNormal];
  [button setTitle:@"退出登录" forState:UIControlStateNormal];
  [view addSubview:button];
  [button mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(view).with.insets(UIEdgeInsetsMake(5, 10, 5, 10));
  }];
  @weakify(self)
  [[button rac_signalForControlEvents:UIControlEventTouchUpInside]
   subscribeNext:^(id x) {
     @strongify(self)
     [MSFUtils.httpClient signOut];
     [MSFUtils setHttpClient:nil];
     [self.navigationController popToRootViewControllerAnimated:YES];
   }];
  
  return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MSFUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.text = self.rowTitles[indexPath.row];
  cell.detailTextLabel.text = self.rowSubtitles[indexPath.row];
  
  return cell;
}

@end
