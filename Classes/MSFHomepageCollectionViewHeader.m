//
// MSFProgressCollectionViewHeader.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageCollectionViewHeader.h"
#import <Masonry/Masonry.h>
//#import <ReactiveCocoa/ReactiveCocoa.h>
//#import "MSFPlanListSegmentBar.h"
#import "MSFTabBarController.h"
#import "MSFTabBarViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFHomePageCellModel.h"
#import "MSFCirculateCashModel.h"

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

- (void)dianwo:(id)sender {
	MSFTabBarController *tab = (MSFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
	MSFHomePageCellModel *model = [[MSFHomePageCellModel alloc] initWithModel:[[MSFCirculateCashModel alloc] init] services:tab.viewModel.services];
	model.jumpDes = 1;
	[model pushDetailViewController];
}

@end
