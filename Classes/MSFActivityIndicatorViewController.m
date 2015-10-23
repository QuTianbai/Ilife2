//
// MSFActivityIndicatorViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFActivityIndicatorViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MSFPoster.h"
#import "MSFUtils.h"

@implementation MSFActivityIndicatorViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	if (!MSFUtils.poster) return;
	[self.backgroundView setImageWithURL:MSFUtils.poster.imageURL placeholderImage:[UIImage imageNamed:@"launch.jpg"]];
}

@end
