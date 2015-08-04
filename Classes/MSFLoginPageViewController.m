//
// MSFPageViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoginPageViewController.h"

@interface MSFLoginPageViewController () <UIScrollViewDelegate>

@property (nonatomic, assign, readwrite) CGFloat offset;

@end

@implementation MSFLoginPageViewController

#pragma mark - Lifecycle

- (NSArray *)pageIdentifiers {
	return @[
		@"MSFSignUpViewController",
		@"MSFSignInViewController"
	];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithWhite:0.976 alpha:1.000];
	self.delegate = self;
	for (UIView *v in self.view.subviews) {
		if ([v isKindOfClass:[UIScrollView class]]) {
			((UIScrollView *)v).delegate = self;
		}
	}
	self.offset = CGRectGetWidth([UIScreen mainScreen].bounds);
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
  
}

#pragma mark - UIPageViewControllerDataSource

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
  return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
  return 0;
}

- (void)setUpViewController:(UIViewController<MSPageViewControllerChild> *)viewController atIndex:(NSInteger)index {
	[super setUpViewController:viewController atIndex:index];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	self.dragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (!decelerate) {
		self.dragging = NO;
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (self.dragging) self.offset = scrollView.contentOffset.x;
}

@end
