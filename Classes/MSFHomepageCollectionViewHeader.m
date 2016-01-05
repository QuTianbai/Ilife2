//
// MSFProgressCollectionViewHeader.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageCollectionViewHeader.h"
#import <Masonry/Masonry.h>
#import "MSFInfinityScroll.h"
#import "MSFHomepageViewModel.h"
#import "MSFAdver.h"

@interface MSFHomepageCollectionViewHeader ()

@property (nonatomic, strong) MSFInfinityScroll *scroll;

@end

@implementation MSFHomepageCollectionViewHeader

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (!self) {
		return nil;
	}
	
	_scroll = [[MSFInfinityScroll alloc] init];
	_scroll.openPageControl = YES;
	_scroll.interval = 5.f;
	_scroll.selectedBlock = ^(NSInteger index) {
		
	};
	[self addSubview:_scroll];
	[_scroll mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	return self;
}

- (void)bindViewModel:(MSFHomepageViewModel *)viewModel {
	_scroll.numberOfPages = ^NSInteger {
		return viewModel.banners.count;
	};
	_scroll.imageUrlAtIndex = ^NSURL *(NSInteger index) {
		MSFAdver *adver = viewModel.banners[index];
		if (adver.image.url.length > 0) {
			return [NSURL URLWithString:adver.image.url];
		}
		return [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"home-banner-pl" ofType:@"png"]];
	};
	[_scroll reloadData];
}

@end
