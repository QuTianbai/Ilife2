//
//  MSFCertificatesCollectionViewController.m
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFCertificatesCollectionViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFCertificateCell.h"
#import "MSFExtraOptionCell.h"
#import "MSFPhotosUploadConfirmView.h"
#import "MSFInventoryViewModel.h"

#import "MSFPhotoUploadCollectionViewController.h"

@interface MSFCertificatesCollectionViewController ()
<UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) MSFInventoryViewModel *viewModel;

@end

@implementation MSFCertificatesCollectionViewController

- (instancetype)initWithViewModel:(id)viewModel {
  self = [self init];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.viewModel.active = NO;
}

- (instancetype)init {
	return [[UIStoryboard storyboardWithName:@"photosUpload" bundle:nil] instantiateViewControllerWithIdentifier:@"MSFCertificatesCollectionViewController"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	@weakify(self)
	[RACObserve(self, viewModel.viewModels) subscribeNext:^(id x) {
		@strongify(self)
		[self.collectionView reloadData];
	}];
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
	if (section == 0) {
		return CGSizeZero;
	} else {
		return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
	}
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
	if (indexPath.section == 0) {
		return CGSizeMake(screenWidth * 0.5, screenWidth * 0.35);
	} else {
		return CGSizeMake(screenWidth, 44);
	}
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	if (section == 0) {
		return UIEdgeInsetsZero;
	} else {
		return UIEdgeInsetsMake(10, 0, 10, 0);
	}
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (section == 0) {
		return 4;
	} else {
		return 1;
	}
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	if (kind == UICollectionElementKindSectionFooter) {
		MSFPhotosUploadConfirmView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MSFPhotosUploadConfirmView" forIndexPath:indexPath];
		return view;
	} else {
		return [UICollectionReusableView new];
	}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		MSFCertificateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFCertificateCell" forIndexPath:indexPath];
		[cell drawSeparatorAtIndex:indexPath total:4];
		return cell;
	} else {
		MSFExtraOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFExtraOptionCell" forIndexPath:indexPath];
		return cell;
	}
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		[self performSegueWithIdentifier:@"photosUploadSegue" sender:nil];
	}
}

#pragma mark - storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"photosUploadSegue"]) {
		MSFPhotoUploadCollectionViewController *vc = (MSFPhotoUploadCollectionViewController *)segue.destinationViewController;
	}
}

@end
