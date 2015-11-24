//
// MSFProgressCollectionViewHeader.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageCollectionViewHeader.h"
#import <Masonry/Masonry.h>

#import "MSFTabBarController.h"
#import "MSFTabBarViewModel.h"
#import "MSFApplyListViewModel.h"

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
	/*
	UIButton *dianwo = [UIButton buttonWithType:UIButtonTypeSystem];
	[dianwo setTitle:@"点我" forState:UIControlStateNormal];
	[dianwo setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
	[dianwo addTarget:self action:@selector(dianwo:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:dianwo];
	[dianwo mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self);
		make.left.equalTo(self);
		make.width.equalTo(@46);
		make.height.equalTo(@36);
	}];*/
	return self;
}

- (void)dianwo:(id)sender {
	MSFTabBarController *tab = (MSFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
	MSFApplyListViewModel *viewModel = [[MSFApplyListViewModel alloc] initWithServices:tab.viewModel.services];
	[tab.viewModel.services pushViewModel:viewModel];
}

@end
