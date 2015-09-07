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
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "MSFPhotosUploadCell.h"
#import "MSFPhotosUploadHeaderView.h"
#import "MSFElementViewModel.h"
#import "MSFElement.h"
#import "MSFAttachmentViewModel.h"
#import "UIColor+Utils.h"

@interface MSFPhotoUploadCollectionViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) MSFElementViewModel *viewModel;
@property (nonatomic, assign) BOOL showExample;

@end

@implementation MSFPhotoUploadCollectionViewController


- (void)bindViewModel:(MSFElementViewModel *)viewModel {
	_viewModel = viewModel;
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	_submitButton.layer.cornerRadius = 5;
	
	[self setUpBackButton];
	
	CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
	CGFloat width = (screenWidth - 30) / 2;
	UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
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
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	[self.viewModel.uploadCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

- (void)setUpBackButton {
	NSInteger total = self.navigationController.viewControllers.count;
	UIViewController *superVc = self.navigationController.viewControllers[total - 2];
	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn.frame = CGRectMake(0, 0, 100, 44);
	[backBtn setTitle:superVc.navigationItem.title forState:UIControlStateNormal];
	[backBtn setTitleColor:[UIColor themeColorNew] forState:UIControlStateNormal];
	backBtn.titleLabel.font = [UIFont systemFontOfSize:17];
	[backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
	[backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
	[backBtn setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
	[[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext:^(id x) {
			if ([SVProgressHUD isVisible]) {
				return;
			}
		 if (!self.viewModel.isCompleted && self.viewModel.attachments.count > 0) {
			 UIAlertView *alert = [[UIAlertView alloc]
														 initWithTitle:nil
														 message:@"您有未提交的图片，需要提交吗？"
														 delegate:nil
														 cancelButtonTitle:@"放弃"
														 otherButtonTitles:@"提交", nil];
			 [alert show];
			 [alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
				 if (x.integerValue == 0) {
					 for (MSFAttachmentViewModel *viewModel in self.viewModel.viewModels) {
						 if (viewModel.removeEnabled) {
							 [viewModel.removeCommand execute:nil];
						 }
					 }
					 [self.navigationController popViewControllerAnimated:YES];
				 } else {
					 [self.viewModel.uploadCommand execute:nil];
				 }
			 }];
			 return;
		 }
		 [self.navigationController popViewControllerAnimated:YES];
	}];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	if (self.viewModel.element.comment.length > 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		CGSize size = [self.viewModel.element.comment sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(collectionView.frame.size.width - 40, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
		return CGSizeMake(collectionView.frame.size.width, 150.f + size.height);
	}
	return CGSizeMake(collectionView.frame.size.width, 150.f);
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
		[[[view.browserButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		 takeUntil:view.rac_prepareForReuseSignal] subscribeNext:^(id x) {
			[self showPhotoBrowser:0 example:YES];
		}];
		return view;
	}
	return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	MSFAttachmentViewModel *viewModel = self.viewModel.viewModels[indexPath.row];
	if (!viewModel.removeEnabled) {
		[[viewModel.takePhotoCommand execute:nil] subscribeNext:^(id x) {
			[self.collectionView reloadData];
		}];
	} else {
		[self showPhotoBrowser:indexPath.row example:NO];
	}
}

#pragma mark - MWPhotoBrowser

- (void)showPhotoBrowser:(NSInteger)curIndex example:(BOOL)b {
	_showExample = b;
	MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
	photoBrowser.enableGrid  = YES;
	photoBrowser.startOnGrid = YES;
	photoBrowser.alwaysShowControls = YES;
	[photoBrowser setCurrentPhotoIndex:curIndex];
	[self.navigationController pushViewController:photoBrowser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
	if (_showExample) {
		return 1;
	}
	MSFAttachmentViewModel *viewModel = [self.viewModel.viewModels lastObject];
	if (viewModel.removeEnabled) {
		return self.viewModel.viewModels.count;
	} else {
		return self.viewModel.viewModels.count - 1;
	}
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
	if (_showExample) {
		MWPhoto *photo = [[MWPhoto alloc] initWithURL:self.viewModel.sampleURL];
		return photo;
	}
	MSFAttachmentViewModel *viewModel = self.viewModel.viewModels[index];
	MWPhoto *photo = [[MWPhoto alloc] initWithURL:viewModel.thumbURL];
	return photo;
}

@end
