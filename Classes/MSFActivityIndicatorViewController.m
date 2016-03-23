//
// MSFActivityIndicatorViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFActivityIndicatorViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MSFPoster.h"
#import "MSFActivate.h"

@implementation MSFActivityIndicatorViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	if (!MSFActivate.poster) return;
	[self.backgroundView setImageWithURL:MSFActivate.poster.imageURL placeholderImage:[UIImage imageNamed:@"launch.png"]];
}

@end
