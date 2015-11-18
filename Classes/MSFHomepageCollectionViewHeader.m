//
// MSFProgressCollectionViewHeader.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageCollectionViewHeader.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFPlanListSegmentBar.h"

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
	MSFPlanListSegmentBar *bar = [[MSFPlanListSegmentBar alloc] initWithTitles:@[@"马上贷", @"麻辣贷", @"麻辣贷", @"麻辣贷", @"麻辣贷"]];
	[bar.executeSelectionCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
		NSLog(@"点击了：%@", x);
	}];
	[self addSubview:bar];
	[bar mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self);
		make.right.equalTo(self);
		make.top.equalTo(self);
		make.height.equalTo(@40);
	}];*/
	
	return self;
}

@end
