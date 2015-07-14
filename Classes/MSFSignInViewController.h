//
// MSFSignInViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	登录－输入
 */
@interface MSFSignInViewController : UITableViewController

@property(nonatomic,weak) IBOutlet UITextField *username;
@property(nonatomic,weak) IBOutlet UITextField *password;
@property(nonatomic,weak) IBOutlet UITextField *captcha;
@property(nonatomic,weak) IBOutlet UILabel *counterLabel;

@property(nonatomic,weak) IBOutlet UIButton *signInButton;
@property(nonatomic,weak) IBOutlet UIButton *captchaButton;
@property(nonatomic,weak) IBOutlet UIButton *findButton;
@property(nonatomic,weak) IBOutlet UISwitch *passwordSwitch;

@end
