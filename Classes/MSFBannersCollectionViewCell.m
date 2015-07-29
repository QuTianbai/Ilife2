//
// MSFBannersCollectionViewCell.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFBannersCollectionViewCell.h"
#import <Masonry/Masonry.h>

@implementation MSFBannersCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
	if (!(self = [super initWithFrame:frame])) {
		return self;
	}
	
	_imageView = UIImageView.new;
	_imageView.contentMode = UIViewContentModeScaleAspectFill;
	_imageView.clipsToBounds = YES;
	[self.contentView addSubview:_imageView];
	[_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.contentView);
	}];
	return self;
}

@end
