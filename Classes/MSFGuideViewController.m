//
// ATGuideManager.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFGuideViewController.h"

#define FORCE_DISPLAY 0

@interface MSFGuideViewController ()

@property (nonatomic, strong) NSArray *paths;

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
      self.paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"guide.bundle"];
    } else {
      self.paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"guide.bundle"];
    }
  }
  return self;
}

- (void)show {
  // 如果存储的版本号小于获取的APP版本号，则显示引导界面,否则不显示
  NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
  NSString *local = [[NSUserDefaults standardUserDefaults] stringForKey:@"CFBundleVersion"];
  NSString *remote = info[@"CFBundleVersion"];
  if (([remote compare:local options:NSNumericSearch] == NSOrderedDescending)) {
    [[NSUserDefaults standardUserDefaults] setObject:remote forKey:@"CFBundleVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  } else {
#if !FORCE_DISPLAY
    return;
#endif
  }
  
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
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
      [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)]];
    }
  }
  [[UIApplication sharedApplication].keyWindow addSubview:scrollView];
}

- (void)dismiss:(UITapGestureRecognizer *)gesture {
  [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    gesture.view.superview.transform = CGAffineTransformMakeScale(1.5, 1.5);
    gesture.view.superview.alpha = 0;
  } completion:^(BOOL finished) {
    [gesture.view.superview removeFromSuperview];
  }];
}

@end
