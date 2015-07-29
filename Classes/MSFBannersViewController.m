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
#import "MSFBannersCollectionViewCell.h"
#import "MSFWebViewController.h"
#import "UIColor+Utils.h"
#import "MSFInfinityScroll.h"

@interface MSFBannersViewController ()

@property (nonatomic, strong) MSFBannersViewModel *viewModel;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation MSFBannersViewController

#pragma mark - Lifecycle

- (instancetype)init {
	CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	flowLayout.itemSize = CGSizeMake(screenWidth, screenWidth/2);
	flowLayout.minimumLineSpacing = 0;
	flowLayout.minimumInteritemSpacing = 0;
	flowLayout.sectionInset = UIEdgeInsetsZero;
	if (!(self = [super initWithCollectionViewLayout:flowLayout])) {
		return nil;
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.pageControl = [[UIPageControl alloc] init];
	self.pageControl.currentPageIndicatorTintColor = UIColor.themeColor;
	self.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.902 alpha:1.000];
	self.pageControl.hidesForSinglePage = YES;
	[self.collectionView.superview addSubview:self.pageControl];
	self.collectionView.backgroundColor = UIColor.blackColor;
	self.collectionView.pagingEnabled = YES;
	self.collectionView.showsVerticalScrollIndicator = NO;
	self.collectionView.showsHorizontalScrollIndicator = NO;
	
	UIView *superview = self.collectionView.superview;
	[self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.equalTo(@30);
		make.bottom.equalTo(superview);
		make.left.equalTo(superview);
		make.right.equalTo(superview);
	}];
	
	self.collectionView.bounces = NO;
	[self.collectionView registerClass:MSFBannersCollectionViewCell.class forCellWithReuseIdentifier:@"Cell"];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
	self.pageControl.numberOfPages = [self.viewModel numberOfItemsInSection:0];
	@weakify(self)
	[self.viewModel.updateContentSignal subscribeNext:^(id x) {
		@strongify(self)
		self.pageControl.numberOfPages = [self.viewModel numberOfItemsInSection:0];
		[self.collectionView reloadData];
	}];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.viewModel numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	MSFBannersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
	[cell.imageView setImageWithURL:[self.viewModel imageURLAtIndexPath:indexPath] placeholderImage:[UIImage imageNamed:[self.viewModel imageNameAtIndexPath:indexPath]]];
	self.pageControl.currentPage = indexPath.item;
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


@end
