//
//  MSFCommodityFooterViewController.m
//  Finance
//
//  Created by xbm on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCommodityFooterViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MSFCommodityViewModel.h"
#import "MSFPhoto.h"

@interface MSFCommodityFooterViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *myPageControll;
@property (nonatomic, weak) MSFCommodityViewModel *viewModel;

@end

@implementation MSFCommodityFooterViewController

#pragma mark - Lifecycle

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	@weakify(self)
	[RACObserve(self, viewModel.photos) subscribeNext:^(NSArray *photos) {
		@strongify(self)
		[self.myScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
		self.myPageControll.numberOfPages = photos.count;
		self.myScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * photos.count, CGRectGetHeight(self.view.bounds));
		[photos enumerateObjectsUsingBlock:^(MSFPhoto *obj, NSUInteger idx, BOOL *stop) {
			UIImageView *imageView = [[UIImageView alloc] init];
			[imageView setImageWithURL:obj.URL];
			imageView.contentMode = UIViewContentModeScaleToFill;
			imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			imageView.frame = CGRectMake(idx * CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
			[self.myScrollView addSubview:imageView];
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
	self.myPageControll.currentPage = currentPage;
}

@end
