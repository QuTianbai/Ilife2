//
// MSFProgressCollectionViewHeader.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageCollectionViewHeader.h"
#import "MSFBannersViewController.h"
#import <Masonry/Masonry.h>
#import "MSFHomepageViewModel.h"

@interface MSFHomepageCollectionViewHeader ()

@property(nonatomic,strong) MSFBannersViewController *bannersViewController;
@property(nonatomic,strong) MSFHomepageViewModel *viewModel;

@end

@implementation MSFHomepageCollectionViewHeader

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (!self) {
		return nil;
	}
	self.bannersViewController = [[MSFBannersViewController alloc] init];
	UIView *bannerView = self.bannersViewController.view;
	[self addSubview:bannerView];
	[bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	return self;
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
	[self.bannersViewController bindViewModel:self.viewModel.bannersViewModel];
}

@end
