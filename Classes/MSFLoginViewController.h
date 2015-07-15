//
// MSFLoginViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	登录
 */

 @class MSFAuthorizeViewModel;

@interface MSFLoginViewController : UIViewController

@property (nonatomic, strong, readonly) MSFAuthorizeViewModel *viewModel;

- (instancetype)initWithViewModel:(MSFAuthorizeViewModel *)viewModel;

@end
