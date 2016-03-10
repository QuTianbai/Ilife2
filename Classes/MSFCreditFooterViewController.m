//
//  MSFCreditFooterViewController.m
//  Finance
//
//  Created by Wyc on 16/3/8.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCreditFooterViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MSFCreditViewModel.h"
#import "MSFPhoto.h"

@interface MSFCreditFooterViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) MSFCreditViewModel *viewModel;

@end

@implementation MSFCreditFooterViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self)
    [RACObserve(self, viewModel.photos) subscribeNext:^(NSArray *photos) {
        
        @strongify(self)
        [self.scrollVIew.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.pageControl.numberOfPages = photos.count;
        self.scrollVIew.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * photos.count, CGRectGetHeight(self.view.bounds));
        [photos enumerateObjectsUsingBlock:^(MSFPhoto *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            UIImageView *imageView = [[UIImageView alloc]init];
            [imageView setImageWithURL:obj.URL];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
            
            imageView.frame = CGRectMake(idx * CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
            [self.scrollVIew addSubview:imageView];
            
        }];
    }];
    
}

- (void)bindViewModel:(id)viewModel {
    self.viewModel = viewModel;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = currentPage;
}

@end
