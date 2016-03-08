//
// MSFHomePageViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFHomepageViewModel;

__attribute__((deprecated("This class is unavailable")))

@interface MSFHomepageViewController : UICollectionViewController

// 主页的viewModel
@property (nonatomic, strong, readonly) MSFHomepageViewModel *viewModel;

- (instancetype)initWithViewModel:(MSFHomepageViewModel *)viewModel;

@end
