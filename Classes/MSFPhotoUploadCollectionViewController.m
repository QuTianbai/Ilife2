//
//  MSFPhotoUploadCollectionViewController.m
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFPhotoUploadCollectionViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFPhotosUploadCell.h"
#import "MSFPhotosUploadHeaderView.h"
#import "MSFPhotosUploadConfirmView.h"
#import "MSFElementViewModel.h"

@interface MSFPhotoUploadCollectionViewController ()

@property (nonatomic, strong) MSFElementViewModel *viewModel;

@end

@implementation MSFPhotoUploadCollectionViewController


- (void)bindViewModel:(MSFElementViewModel *)viewModel {
	_viewModel = viewModel;
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
	CGFloat width = (screenWidth - 60) / 2;
	UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
	layout.headerReferenceSize = CGSizeMake(screenWidth, 145);
	layout.footerReferenceSize = CGSizeMake(screenWidth, 70);
	layout.itemSize = CGSizeMake(width, width * 0.7);
	layout.minimumInteritemSpacing = 20;
	layout.minimumLineSpacing = 20;
	layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
	
	@weakify(self)
	[RACObserve(self, viewModel.attachments) subscribeNext:^(id x) {
		@strongify(self)
		[self.collectionView reloadData];
	}];

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.attachments.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	MSFPhotosUploadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFPhotosUploadCell" forIndexPath:indexPath];
	
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	if (kind == UICollectionElementKindSectionHeader) {
		MSFPhotosUploadHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MSFPhotosUploadHeaderView" forIndexPath:indexPath];
		return view;
	} else {
		MSFPhotosUploadConfirmView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MSFPhotosUploadConfirmView" forIndexPath:indexPath];
		return view;
	}
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
}

@end
