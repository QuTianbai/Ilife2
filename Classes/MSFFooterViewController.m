//
// MSFFooterViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFFooterViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MSFWalletViewModel.h"
#import "MSFPhoto.h"

@interface MSFFooterViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) MSFWalletViewModel *viewModel;

@end

@implementation MSFFooterViewController

#pragma mark - Lifecycle

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	@weakify(self)
	[RACObserve(self, viewModel.photos) subscribeNext:^(NSArray *photos) {
		@strongify(self)
		[self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
		self.pageControl.numberOfPages = photos.count;
		self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * photos.count, CGRectGetHeight(self.view.bounds));
		[photos enumerateObjectsUsingBlock:^(MSFPhoto *obj, NSUInteger idx, BOOL *stop) {
			UIImageView *imageView = [[UIImageView alloc] init];
			[imageView setImageWithURL:obj.URL];
			imageView.contentMode = UIViewContentModeScaleAspectFill;
			imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			imageView.frame = CGRectMake(idx * CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
			[self.scrollView addSubview:imageView];
		}];
	}];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  CGFloat pageWidth = scrollView.frame.size.width;
  int currentPage  = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	self.pageControl.currentPage = currentPage;
}

@end
