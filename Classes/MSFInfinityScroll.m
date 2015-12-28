//
//  MSFInfinityScroll.m
//  Finance
//
//  Created by 赵勇 on 12/14/15.
//  Copyright © 2015 MaShang Consumer Finance Co., Ltd. All rights reserved.
//

#import "MSFInfinityScroll.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MSFInfinityScroll () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, strong) UIPageControl  *pageControl;
@property (nonatomic, strong) NSTimer        *timer;

// 三个imageView的数组
@property (nonatomic, strong) NSMutableArray *contents;
// 需要展示的内容的数组，url或者图片名称
@property (nonatomic, strong) NSMutableArray *displayItems;
// 当前scrollView滚动的比例
@property (nonatomic, assign) CGFloat        offsetRatio;
// 当前选中的index
@property (nonatomic, assign) NSInteger visiableIndex;

@property (nonatomic, assign) BOOL           timerForce;

@end

@implementation MSFInfinityScroll

- (void)dealloc {
	if (_timer.valid) [_timer invalidate];
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_contents = [NSMutableArray array];
		_displayItems = [NSMutableArray arrayWithArray:@[@0, @0, @0]];
		
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_scrollView.backgroundColor = UIColor.clearColor;
		_scrollView.pagingEnabled = YES;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.showsVerticalScrollIndicator   = NO;
		_scrollView.delegate = self;
		[self addSubview:_scrollView];
		
		for (int i = 0; i < 3; i++) {
			UIImageView *imageView = [[UIImageView alloc] init];
			imageView.contentMode = UIViewContentModeScaleAspectFill;
			imageView.clipsToBounds = YES;
			imageView.userInteractionEnabled = YES;
			[self addSubview:imageView];
			UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
			[imageView addGestureRecognizer:tapGesture];
			[_scrollView addSubview:imageView];
			[_contents addObject:imageView];
		}
		
		self.interval = 0;
		self.openPageControl = YES;
		self.visiableIndex = 0;
	}
	return self;
}

- (void)tap:(UITapGestureRecognizer *)tap {
	NSInteger total = self.numberOfPages() ? self.numberOfPages() : 0;
	if (_selectedBlock && total > 0) {
		_selectedBlock(self.visiableIndex);
	}
}

- (void)reloadData {
	NSInteger total = [self numberOfViews];
	_scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 3, CGRectGetHeight(self.frame));
	
	if (total == 0) {
		for (int i = 0; i < 3; i++) {
			UIImageView *imageView = [self.contents objectAtIndex:i];
			imageView.image = nil;
		}
	} else {
		for (int i = 0; i < 3; i++) {
			NSInteger thisPage = [self validIndexValue:i];
			if (self.imageUrlAtIndex) {
				[self.displayItems replaceObjectAtIndex:i withObject:self.imageUrlAtIndex(thisPage)];
			}
			if (self.imageNameAtIndex) {
				[self.displayItems replaceObjectAtIndex:i withObject:self.imageNameAtIndex(thisPage)];
			}
		}
		for (int i = 0; i < 3; i++) {
			UIImageView *imageView = [self.contents objectAtIndex:i];
			imageView.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
			if (self.imageUrlAtIndex) {
				NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.displayItems[i]];
				[request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
				__weak typeof(imageView) weakImageView = imageView;
				[imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
					weakImageView.image = image;
					if (i == 1 && _visiableImageChanged) {
						_visiableImageChanged(image);
					}
				} failure:nil];
			}
			if (self.imageNameAtIndex) {
				UIImage *image = [UIImage imageNamed:self.displayItems[i]];
				imageView.image = image;
				if (i == 1 && _visiableImageChanged) {
					_visiableImageChanged(image);
				}
			}
		}
	}
	
	[_scrollView setContentOffset:CGPointMake(self.frame.size.width + self.frame.size.width * self.offsetRatio, 0)];
	
	if (total > 1) {
		if (self.interval > 0) {
			[self timerContinue];
		}
		_scrollView.scrollEnabled = YES;
	} else {
		[self timerInvalidate];
		_scrollView.scrollEnabled = NO;
	}
}

- (NSInteger)validIndexValue:(NSInteger)value {
	
	if (value == 0) {
		if (self.visiableIndex - 1 < 0) {
			return [self numberOfViews] - 1;
		} else {
			return self.visiableIndex - 1;
		}
	}
	
	if (value == 2) {
		if (self.visiableIndex + 1 == [self numberOfViews]) {
			return 0;
		} else {
			return self.visiableIndex + 1;
		}
	}
	
	return self.visiableIndex;
}

- (NSInteger)numberOfViews {
	NSInteger num = 0;
	if (self.numberOfPages) num = self.numberOfPages();
	if (_pageControl) _pageControl.numberOfPages = num;
	return num;
}

- (void)setOpenPageControl:(BOOL)openPageControl {
	if (_openPageControl == openPageControl) return;
	_openPageControl = openPageControl;
	if (openPageControl) {
		if (!_pageControl) {
			_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 50, self.frame.size.height - 20, 100, 20)];
			_pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
			_pageControl.hidesForSinglePage = YES;
			[self addSubview:_pageControl];
		}
		_pageControl.hidden = NO;
	} else {
		if (_pageControl) _pageControl.hidden = YES;
	}
}

- (void)timerFire {
	_timerForce = YES;
	[_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * 2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
}

- (void)timerContinue {
	if ([_timer isValid]) {
		[_timer invalidate];
	}
	_timer = [NSTimer scheduledTimerWithTimeInterval:_interval
																						target:self
																					selector:@selector(timerFire)
																					userInfo:nil
																					 repeats:YES];
}

- (void)timerInvalidate {
	[_timer invalidate];
}

- (void)setInterval:(NSTimeInterval)interval {
	if (_interval == interval) return;
	_interval = interval;
	if (_interval > 0) {
		[self timerContinue];
	} else {
		[self timerInvalidate];
	}
}

- (void)setVisiableIndex:(NSInteger)visiableIndex {
	if (_visiableIndex != visiableIndex) {
		_visiableIndex = visiableIndex;
		if (_pageControl) _pageControl.currentPage = visiableIndex;
		[self reloadData];
	}
}

- (void)setOffsetRatio:(CGFloat)offsetRatio {
	
	if (_offsetRatio != offsetRatio) {
		_offsetRatio = offsetRatio;
		
		if (offsetRatio > 0.5) {
			_offsetRatio = offsetRatio - 1;
			self.visiableIndex = [self validIndexValue:2];
		}
		
		if (offsetRatio < -0.5) {
			_offsetRatio = offsetRatio + 1;
			self.visiableIndex = [self validIndexValue:0];
		}
	}
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if (_timerForce) {
		_timerForce = NO;
		self.visiableIndex = [self validIndexValue:2];
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	_timerForce = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self timerInvalidate];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	[self timerContinue];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	self.offsetRatio = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame) - 1;
}

@end
