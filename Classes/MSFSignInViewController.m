//
// MSFSignInViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSignInViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>

@implementation MSFSignInViewController

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFSignInViewController `-dealloc`");
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-login"]];
}

@end
