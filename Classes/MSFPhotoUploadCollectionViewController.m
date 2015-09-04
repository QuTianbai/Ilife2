//
//  MSFPhotoUploadCollectionViewController.m
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFPhotoUploadCollectionViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFPhotosUploadCell.h"
#import "MSFPhotosUploadHeaderView.h"
#import "MSFElementViewModel.h"
#import "MSFAttachmentViewModel.h"

@interface MSFPhotoUploadCollectionViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) MSFElementViewModel *viewModel;

@end

@implementation MSFPhotoUploadCollectionViewController


- (void)bindViewModel:(MSFElementViewModel *)viewModel {
	_viewModel = viewModel;
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	_submitButton.layer.cornerRadius = 5;
	
	CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
	CGFloat width = (screenWidth - 30) / 2;
	UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
	layout.headerReferenceSize = CGSizeMake(screenWidth, 145);
	layout.itemSize = CGSizeMake(width, (width - 20) * 0.62 + 20);
	layout.minimumInteritemSpacing = 10;
	layout.minimumLineSpacing = 10;
	layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
	
	@weakify(self)
	[RACObserve(self, viewModel.viewModels) subscribeNext:^(id x) {
		@strongify(self)
		[self.collectionView reloadData];
	}];
	
	self.submitButton.rac_command = self.viewModel.uploadCommand;
	[self.viewModel.uploadCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeNone];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			if (_completionBlock) {
				_completionBlock();
			}
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	[self.viewModel.uploadCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.viewModel.viewModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	MSFPhotosUploadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFPhotosUploadCell" forIndexPath:indexPath];
	[cell bindViewModel:self.viewModel.viewModels[indexPath.row]];
	return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	if (kind == UICollectionElementKindSectionHeader) {
		MSFPhotosUploadHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MSFPhotosUploadHeaderView" forIndexPath:indexPath];
		[view bindModel:self.viewModel];
		return view;
	}
	return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	if (indexPath.row == self.viewModel.viewModels.count - 1) {
		MSFAttachmentViewModel *viewModel = self.viewModel.viewModels[indexPath.row];
		[[viewModel.takePhotoCommand execute:nil] subscribeNext:^(id x) {
			[self.collectionView reloadData];
		}];
	}
}

@end
