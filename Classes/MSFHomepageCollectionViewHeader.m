//
// MSFProgressCollectionViewHeader.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageCollectionViewHeader.h"
#import <Masonry/Masonry.h>

@interface MSFHomepageCollectionViewHeader ()

@end

@implementation MSFHomepageCollectionViewHeader

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (!self) {
		return nil;
	}
	UIImageView *bannerView = [[UIImageView alloc] init];
	bannerView.image = [UIImage imageNamed:@"home-banner-pl.png"];
	[self addSubview:bannerView];
	[bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	return self;
}

@end
