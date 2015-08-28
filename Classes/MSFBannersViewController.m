//
// MSFBannersViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFBannersViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <Masonry/Masonry.h>
#import "MSFUtils.h"
#import "MSFBannersViewModel.h"
#import "MSFWebViewController.h"
#import "UIColor+Utils.h"
#import "MSFInfinityScroll.h"

@interface MSFBannersViewController ()

@property (nonatomic, strong) MSFBannersViewModel *viewModel;
@property (nonatomic, strong) MSFInfinityScroll *infinityScroll;

@end

@implementation MSFBannersViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width / 2.162);
	self.infinityScroll = [[MSFInfinityScroll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[self.view addSubview:self.infinityScroll];
	[self.infinityScroll mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	@weakify(self);
	self.infinityScroll.numberOfPages = ^{
		@strongify(self)
		NSInteger num = [self.viewModel numberOfItemsInSection:0];
		if (num == 0) {
			num = 1;
		}
		return num;
	};
	
	if ([self.viewModel numberOfItemsInSection:0] == 0) {
		self.infinityScroll.imageNameAtIndex = ^(NSInteger index) {
			return @"home-banner-pl.png";
		};
	} else {
		self.infinityScroll.imageUrlAtIndex = ^(NSInteger index){
			@strongify(self)
			return [self.viewModel imageURLAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
		};
	}

	self.infinityScroll.selectedBlock = ^(NSInteger index) {
		NSLog(@"选择了---%ld", (long) index);

	};

}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
	[self.infinityScroll reloadData];
	@weakify(self)
	[self.viewModel.updateContentSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.infinityScroll reloadData];
	}];
}

@end
