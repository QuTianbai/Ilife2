//
//  MSFInfinityScroll.m
//  Finance
//
//  Created by 赵勇 on 7/29/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFInfinityScroll.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MSFInfinityScroll () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *contents;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, assign) CGFloat        offsetRatio;
@property (nonatomic, assign) NSInteger      visiableIndex;
@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, strong) UIPageControl  *pageControl;
@property (nonatomic, strong) NSTimer        *timer;
@property (nonatomic, assign) BOOL           timerForce;

@end

@implementation MSFInfinityScroll

- (void) dealloc {
	if (_timer.valid) [_timer invalidate];
}

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void) commonInit {
	self.contents = [NSMutableArray array];
	self.urls = [NSMutableArray array];
	
	for (int i=0; i<3; i++) {
		[self.urls addObject:[NSNull null]];
	}
	
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	_scrollView.backgroundColor  = [UIColor clearColor];
	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	_scrollView.pagingEnabled = YES;
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator   = NO;
	_scrollView.delegate = self;
	[self addSubview:_scrollView];
	
	for (int i = 0; i < 3; i++) {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height)];
		imageView.contentMode = UIViewContentModeScaleAspectFill;
		imageView.userInteractionEnabled = YES;
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
		[imageView addGestureRecognizer:tapGesture];
		[_scrollView addSubview:imageView];
		[_contents addObject:imageView];
	}
	
	_visiableIndex = 0;
}

- (void) tap:(UITapGestureRecognizer *)tap {
	NSInteger total = self.numberOfPages() ? self.numberOfPages() : 0;
	if (_selectedBlock && total > 0) {
		_selectedBlock(_visiableIndex);
	}
}

- (void) layoutSubviews {
	[self reloadData];
}

- (void)reloadData {
	
	NSInteger total = [self numberOfViews];
	_scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*3, CGRectGetHeight(self.frame));
	
	if (total == 0) {
		for (int i = 0; i < 3; i++) {
			UIImageView *imageView = [self.contents objectAtIndex:i];
			imageView.image = [UIImage imageNamed:@"ic_placeholder_hd"];
		}
	}else{
		for (int i=0; i<3; i++) {
			NSInteger thisPage = [self validIndexValue: i];
			if (self.imageUrlAtIndex) [self.urls replaceObjectAtIndex:i withObject:self.imageUrlAtIndex(thisPage)];
		}
		for (int i = 0; i < 3; i++) {
			UIImageView *imageView = [self.contents objectAtIndex:i];
			imageView.frame = CGRectMake(self.frame.size.width*i, 0, self.frame.size.width, self.frame.size.height);
			NSString *url = [self.urls objectAtIndex:i];
			[imageView setImageWithURL:[NSURL URLWithString:url]];
		}
	}
	
	
	[_scrollView setContentOffset:CGPointMake(self.frame.size.width + self.frame.size.width * self.offsetRatio, 0)];
	
	if (total > 1) {
		if (self.play && !_scrollView.scrollEnabled) [self timerContinue];
		_scrollView.scrollEnabled = YES;
	}else {
		[self timerPause];
		_scrollView.scrollEnabled = NO;
	}
}

- (NSInteger)validIndexValue:(NSInteger)value {
	
	if (value == 0) {
		if (self.visiableIndex - 1 < 0) {
			return [self numberOfViews] - 1;
		}else {
			return self.visiableIndex - 1;
		}
	}
	
	if (value == 2) {
		if (self.visiableIndex + 1 == [self numberOfViews]) {
			return 0;
		}else{
			return self.visiableIndex + 1;
		}
	}
	
	return self.visiableIndex;
}

- (NSInteger) numberOfViews {
	NSInteger num = 0;
	if (self.numberOfPages) num = self.numberOfPages();
	if (_pageControl) _pageControl.numberOfPages = num;
	return num;
}

- (void) setOpenPageControl:(BOOL)openPageControl {
	if (_openPageControl == openPageControl) return;
	_openPageControl = openPageControl;
	if (openPageControl) {
		if (!_pageControl) {
			_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width/2-50, self.frame.size.height-20, 100, 20)];
			_pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
			_pageControl.hidesForSinglePage = YES;
			[self addSubview:_pageControl];
		}
		_pageControl.hidden = NO;
	}else {
		if (_pageControl) _pageControl.hidden = YES;
	}
}

- (void) timerFire {
	_timerForce = YES;
	[_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width*2, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
}

- (void) timerContinue {
	_timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
}

- (void) timerPause {
	[_timer invalidate];
}

- (void) setPlay:(BOOL)play {
	if (_play == play) return;
	_play = play;
	if (play) [self timerContinue];
	else [self timerPause];
	
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
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if (_timerForce) {
		_timerForce = NO;
		self.visiableIndex = [self validIndexValue:2];
	}
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	_timerForce = NO;
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self timerPause];
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	[self timerContinue];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	self.offsetRatio = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame) - 1;
}

@end
