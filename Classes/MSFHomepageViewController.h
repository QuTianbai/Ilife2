//
// MSFHomePageViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFHomepageViewModel;
/**
 *	首页
 */
@interface MSFHomepageViewController : UICollectionViewController

@property (nonatomic, strong, readonly) MSFHomepageViewModel *viewModel;

- (instancetype)initWithViewModel:(MSFHomepageViewModel *)viewModel;

@end
