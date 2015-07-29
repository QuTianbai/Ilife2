//
// MSFPlaceholderCollectionViewCell.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPlaceholderCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Utils.h"

@implementation MSFPlaceholderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (!self) {
		return nil;
	}
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home-fourStatus.png"]];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.clipsToBounds = YES;
	[self.contentView addSubview:imageView];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.contentView);
		make.width.equalTo(@(self.contentView.frame.size.width / 2));
		make.height.equalTo(@(self.contentView.frame.size.width / 2));
	}];
	
	return self;
}

- (void)bindViewModel:(id)viewModel {
	
}

@end
