//
// MSFUnauthenticViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAuthorizationViewController.h"
#import <Masonry/Masonry.h>

@implementation MSFAuthorizationViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIImageView *imageView = [UIImageView new];
	imageView.image = [UIImage imageNamed:@"bk-iphone6plus.jpg"];
	[self.view addSubview:imageView];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
}

@end
