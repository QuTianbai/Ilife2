//
// MSFHomePageViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFHomepageViewModel;

@interface MSFHomepageViewController : UICollectionViewController

// 主页的viewModel
@property (nonatomic, strong, readonly) MSFHomepageViewModel *viewModel;

/*
 * 用viewModel初始化
 *
 * viewModel：主页的viewModel
 *
 * 返回MSFHomepageViewController对象
 */
- (instancetype)initWithViewModel:(MSFHomepageViewModel *)viewModel;

@end
