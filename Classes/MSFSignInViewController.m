//
// MSFSignInViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSignInViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>

@implementation MSFSignInViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-login"]];
  self.passwordSwitch.on = NO;
  
  @weakify(self)
  [[self.passwordSwitch rac_newOnChannel] subscribeNext:^(NSNumber *x) {
    @strongify(self)
    [self.password setSecureTextEntry:!x.boolValue];
  }];
}

@end
