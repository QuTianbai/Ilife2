//
// ATGuideManager.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFGuideViewController.h"
#import "RCLocationManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#define FORCE_DISPLAY 0

@interface MSFGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *paths;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation MSFGuideViewController

+ (instancetype)guide {
	static MSFGuideViewController *guide;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		guide = [[MSFGuideViewController alloc] init];
	});
	
	return guide;
}

- (id)init {
	if (self = [super init]) {
		if ([[UIScreen mainScreen] bounds].size.height >= 568) {
			self.paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:@"guide"];
		} else {
			self.paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"guide"];
		}
	}
	return self;
}

- (void)show {
	// 如果存储的版本号小于获取的APP版本号，则显示引导界面,否则不显示
	NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
	NSString *local = [[NSUserDefaults standardUserDefaults] stringForKey:@"CFBundleVersion"];
	NSString *remote = info[@"CFBundleVersion"];
	if (!([remote compare:local options:NSNumericSearch] == NSOrderedDescending)) {
		[[NSUserDefaults standardUserDefaults] setObject:remote forKey:@"CFBundleVersion"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} else {
#if !FORCE_DISPLAY
		return;
#endif
	}
	CGRect frame = [UIScreen mainScreen].bounds;
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
	scrollView.delegate = self;
	scrollView.pagingEnabled = YES;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.bounces = NO;
	scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.bounds) * self.paths.count, CGRectGetHeight(scrollView.bounds));
	
	CGRect(^guideFrame)(CGRect, NSInteger) = ^(CGRect frame, NSInteger index) {
		frame.origin.x = index * CGRectGetWidth(frame);
		return frame;
	};
	
	for (int i = 0; i < _paths.count; i++) {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
		imageView.image = [UIImage imageWithContentsOfFile:_paths[i]];
		imageView.frame = guideFrame(imageView.frame, i);
		[scrollView addSubview:imageView];
		
		if (i == self.paths.count - 1) {
			imageView.userInteractionEnabled = YES;
			
			UIImage *titleImg = [UIImage imageNamed:@"icon-start-title"];
			
			UIImageView *titleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width / 2 - 100, 30, 200, 200 * titleImg.size.height / titleImg.size.width)];
			titleImgView.image = titleImg;
			[imageView addSubview:titleImgView];
			
			UIImage *signinImg = [UIImage imageNamed:@"icon-start-signin"];
			
			UIButton *signinButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - signinImg.size.width - 5, 35, 52, 52 * signinImg.size.height / signinImg.size.width)];
			[signinButton setBackgroundImage:signinImg forState:UIControlStateNormal];
			[imageView addSubview:signinButton];
			[[signinButton rac_signalForControlEvents:UIControlEventTouchUpInside]
			 subscribeNext:^(id x) {
				 [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					 scrollView.transform = CGAffineTransformMakeScale(1.5, 1.5);
					 scrollView.alpha = 0;
				 } completion:^(BOOL finished) {
					 [scrollView removeFromSuperview];
					 [[RCLocationManager sharedManager] requestUserLocationAlwaysOnce:^(CLLocationManager *manager, CLAuthorizationStatus status) {
						 [manager startUpdatingLocation];
					 }];
				 }];
			 }];
			
			UIImage *img = [UIImage imageNamed:@"icon-start-signup"];
			UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, frame.size.height - 70, frame.size.width - 40, (frame.size.width - 40) * img.size.height / img.size.width)];
			[button setBackgroundImage:img forState:UIControlStateNormal];
			[imageView addSubview:button];
			[[button rac_signalForControlEvents:UIControlEventTouchUpInside]
			subscribeNext:^(id x) {
				[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					scrollView.transform = CGAffineTransformMakeScale(1.5, 1.5);
					scrollView.alpha = 0;
				} completion:^(BOOL finished) {
					[scrollView removeFromSuperview];
					[[RCLocationManager sharedManager] requestUserLocationAlwaysOnce:^(CLLocationManager *manager, CLAuthorizationStatus status) {
						[manager startUpdatingLocation];
					}];
				}];
			}];
			
			
			
//			[imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)]];
		}
	}
	[[UIApplication sharedApplication].keyWindow addSubview:scrollView];
	
	self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(frame.size.width / 2 - 50, frame . size . height - 30, 100, 30)];
	self.pageControl.numberOfPages = self.paths.count;
	[[UIApplication sharedApplication].keyWindow addSubview:self.pageControl];
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	int cureent = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
	
	self.pageControl.currentPage = cureent;
	
}

- (void)dismiss:(UITapGestureRecognizer *)gesture {
	[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		gesture.view.superview.transform = CGAffineTransformMakeScale(1.5, 1.5);
		gesture.view.superview.alpha = 0;
	} completion:^(BOOL finished) {
		[gesture.view.superview removeFromSuperview];
		[[RCLocationManager sharedManager] requestUserLocationAlwaysOnce:^(CLLocationManager *manager, CLAuthorizationStatus status) {
			[manager startUpdatingLocation];
		}];
	}];
}

@end
