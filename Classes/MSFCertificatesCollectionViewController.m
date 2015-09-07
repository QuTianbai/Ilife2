//
//  MSFCertificatesCollectionViewController.m
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFCertificatesCollectionViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <libextobjc/extobjc.h>
#import <KGModal/KGModal.h>
#import "MSFCertificateCell.h"
#import "MSFExtraOptionCell.h"
#import "MSFInventoryViewModel.h"
#import "MSFElementViewModel.h"
#import "MSFHeaderView.h"

#import "MSFAlertViewModel.h"
#import "MSFAlertViewController.h"
#import "MSFFormsViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFUser.h"
#import "MSFClient.h"



#import "MSFPhotoUploadCollectionViewController.h"

@interface MSFCertificatesCollectionViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) MSFInventoryViewModel *viewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

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

- (instancetype)init {
	return [[UIStoryboard storyboardWithName:@"photosUpload" bundle:nil] instantiateViewControllerWithIdentifier:@"MSFCertificatesCollectionViewController"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.submitButton.layer.cornerRadius = 5;
	[self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"MSFBlankSpaceCell"];
	[self.collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MSFHeaderReuseView"];

	@weakify(self)
	[RACObserve(self, viewModel.viewModels) subscribeNext:^(id x) {
		@strongify(self)
		[self.collectionView reloadData];
	}];
	
	[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		MSFAlertViewModel *viewModel = [[MSFAlertViewModel alloc] initWithFormsViewModel:self.viewModel.formsViewModel user:[self.viewModel.formsViewModel.services httpClient].user];
		MSFAlertViewController *alertViewController = [[MSFAlertViewController alloc] initWithViewModel:viewModel];
		
		[[KGModal sharedInstance] setModalBackgroundColor:[UIColor whiteColor]];
		[[KGModal sharedInstance] setShowCloseButton:NO];
		[[KGModal sharedInstance] showWithContentViewController:alertViewController];
		
		[viewModel.buttonClickedSignal subscribeNext:^(id x) {
			[[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^{
				[self.viewModel.executeUpdateCommand execute:nil];
			}];
		} completed:^{
			[[KGModal sharedInstance] hideAnimated:YES];
		}];
	}];
	
	[self.viewModel.executeUpdateCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeNone];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"提交成功"];
			[self.tabBarController setSelectedIndex:0];
			[self.navigationController popToRootViewControllerAnimated:NO];
		}];
	}];
	
	[self.viewModel.executeUpdateCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	if (!self.optional) {
		self.viewModel.active = YES;
	} else {
		self.constraint.constant = 0;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.collectionView reloadData];
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	if (section == 0 && !self.optional) {
		return CGSizeMake([UIScreen mainScreen].bounds.size.width, 90);
	} else {
		return CGSizeZero;
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
	if (self.optional) {
		return 1;
	}
	return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if (self.optional) {
		if (self.viewModel.optionalViewModels.count % 2 == 0) {
			return self.viewModel.optionalViewModels.count;
		} else {
			return self.viewModel.optionalViewModels.count + 1;
		}
	}
	if (section == 0) {
		if (self.viewModel.requiredViewModels.count % 2 == 0) {
			return self.viewModel.requiredViewModels.count;
		} else {
			return self.viewModel.requiredViewModels.count + 1;
		}
	} else {
		return 1;
	}
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	if (kind == UICollectionElementKindSectionHeader) {
		UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MSFHeaderReuseView" forIndexPath:indexPath];
		MSFHeaderView *header = [MSFHeaderView headerViewWithIndex:3];
		header.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		[view addSubview:header];
		return view;
	}
	return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		
		NSInteger totalCount = 0;
		if (self.optional) {
			totalCount = self.viewModel.optionalViewModels.count;
		} else {
			totalCount = self.viewModel.requiredViewModels.count;
		}
		
		if (totalCount % 2 != 0 && indexPath.row == totalCount) {
			UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFBlankSpaceCell" forIndexPath:indexPath];
			cell.backgroundColor = [UIColor whiteColor];
			return cell;
		} else {
			MSFCertificateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFCertificateCell" forIndexPath:indexPath];
			if (self.optional) {
				[cell bindViewModel:self.viewModel.optionalViewModels[indexPath.row]];
			} else {
				[cell bindViewModel:self.viewModel.requiredViewModels[indexPath.row]];
			}
			[cell drawSeparatorAtIndex:indexPath total:totalCount];
			return cell;
		}
	} else {
		MSFExtraOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFExtraOptionCell" forIndexPath:indexPath];
		return cell;
	}
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		NSInteger totalCount = 0;
		if (self.optional) {
			totalCount = self.viewModel.optionalViewModels.count;
		} else {
			totalCount = self.viewModel.requiredViewModels.count;
		}
		if (totalCount % 2 == 0 || indexPath.row != totalCount) {
			[self performSegueWithIdentifier:@"photosUploadSegue" sender:indexPath];
		}
	} else {
		MSFCertificatesCollectionViewController *vc = [[MSFCertificatesCollectionViewController alloc] initWithViewModel:self.viewModel];
		vc.navigationItem.title = @"上传更多资料";
		vc.optional = YES;
		[self.navigationController pushViewController:vc animated:YES];
	}
}

#pragma mark - storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"photosUploadSegue"]) {
		NSIndexPath *indexPath = sender;
		MSFPhotoUploadCollectionViewController *vc = (MSFPhotoUploadCollectionViewController *)segue.destinationViewController;
		if (self.optional) {
			MSFElementViewModel *viewModel = self.viewModel.optionalViewModels[indexPath.row];
			vc.title = viewModel.title;
			[vc bindViewModel:viewModel];
		} else {
			MSFElementViewModel *viewModel = self.viewModel.requiredViewModels[indexPath.row];
			vc.title = viewModel.title;
			[vc bindViewModel:viewModel];
		}
	}
}

@end