//
// MSFSignInViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	登录
 */

@class MSFAuthorizeViewModel;

@interface MSFSignInViewController : UITableViewController

@property(nonatomic,weak) IBOutlet UITextField *username;
@property(nonatomic,weak) IBOutlet UITextField *password;
@property(nonatomic,weak) IBOutlet UIButton *signInButton;
@property (nonatomic, strong, readonly) MSFAuthorizeViewModel *viewModel;

- (instancetype)initWithViewModel:(MSFAuthorizeViewModel *)viewModel;

@end
