//
//  MSFCertificatesCollectionViewController.m
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFInventoryViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <Mantle/EXTScope.h>
#import <KGModal/KGModal.h>
#import "MSFInventoryTableViewCell.h"
#import "MSFBlankCell.h"
#import "MSFExtraOptionCell.h"
#import "MSFInventoryViewModel.h"
#import "MSFElementViewModel.h"
#import "MSFHeaderView.h"

#import "MSFAlertViewModel.h"
#import "MSFAlertViewController.h"
#import "MSFViewModelServices.h"
#import "MSFUser.h"
#import "MSFClient.h"
#import "MSFApplyCashViewModel.h"
#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFCartViewModel.h"
#import "MSFElementViewController.h"
#import "MSFHeaderView.h"
#import "MSFCommitedViewController.h"

@interface MSFInventoryViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) MSFInventoryViewModel *viewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headLayoutHeight;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation MSFInventoryViewController

- (instancetype)initWithViewModel:(id)viewModel {
  self = [self init];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  
  return self;
}

- (void)dealloc {
	NSLog(@"MSFInventoryViewController `-dealloc`");
}

- (instancetype)init {
	return [[UIStoryboard storyboardWithName:@"photosUpload" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(MSFInventoryViewController.class)];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.submitButton.layer.cornerRadius = 5;
	[self.collectionView registerClass:MSFBlankCell.class forCellWithReuseIdentifier:@"MSFBlankCell"];
	[self.collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MSFHeaderReuseView"];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

	@weakify(self)
	[RACObserve(self, viewModel.viewModels) subscribeNext:^(id x) {
		@strongify(self)
		[self.collectionView reloadData];
	}];
	[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.updateValidSignal subscribeNext:^(id x) {
			if ([self.viewModel.applicationViewModel isKindOfClass:[MSFSocialInsuranceCashViewModel class]]) {
				[[self.viewModel.executeUpdateCommand execute:nil] subscribeNext:^(id x) {
					[self.viewModel.executeSubmitCommand execute:nil];
				}];
			} else if ([self.viewModel.applicationViewModel isKindOfClass:[MSFApplyCashViewModel class]]) {
				[[KGModal sharedInstance] setModalBackgroundColor:[UIColor whiteColor]];
				[[KGModal sharedInstance] setShowCloseButton:NO];
				[[self.viewModel.executeUpdateCommand execute:nil] subscribeNext:^(id x) {
					MSFAlertViewModel *viewModel = [[MSFAlertViewModel alloc] initWithFormsViewModel:self.viewModel.applicationViewModel
						user:[self.viewModel.applicationViewModel.services httpClient].user];
					MSFAlertViewController *alertViewController = [[MSFAlertViewController alloc] initWithViewModel:viewModel];
					[[KGModal sharedInstance] showWithContentViewController:alertViewController];
					[viewModel.buttonClickedSignal subscribeNext:^(id x) {
						[[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^{
							[self.viewModel.executeSubmitCommand execute:nil];
						}];
					} completed:^{
						[[KGModal sharedInstance] hideAnimated:YES];
					}];
				}];
				
			} else if ([self.viewModel.applicationViewModel isKindOfClass:[MSFCartViewModel class]]) {
				[[self.viewModel.executeUpdateCommand execute:nil] subscribeNext:^(id x) {
					[(MSFCartViewModel *)self.viewModel.applicationViewModel setAccessories:x];
					[self.viewModel.executeSubmitCommand execute:nil];
				}];
			} else {
				[[self.viewModel.executeUpdateCommand execute:nil] subscribeNext:^(id x) {
					[self.viewModel.executeSubmitCommand execute:nil];
				}];
			}
		} error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
	}];
	
	[self.viewModel.executeUpdateCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[signal subscribeNext:^(id x) {
			self.viewModel.applicationViewModel.accessories = x;
		}];
	}];
	[self.viewModel.executeUpdateCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];

	
	[self.viewModel.executeSubmitCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeNone];
		[signal subscribeNext:^(id x) {
				[SVProgressHUD showSuccessWithStatus:@"提交成功"];
				[self.navigationController setViewControllers:@[
					self.navigationController.viewControllers.firstObject,
					[[MSFCommitedViewController alloc] init]
				] animated:YES];
		}];
	}];
	
	[self.viewModel.executeSubmitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	if (!self.optional) {
		self.viewModel.active = YES;
		[self.headerView addSubview:[MSFHeaderView headerViewWithIndex:2]];
	} else {
		self.constraint.constant = 0;
		self.headLayoutHeight.constant = 0;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.collectionView reloadData];
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
	if (indexPath.section == 0) {
		return CGSizeMake(screenWidth * 0.5, floor(screenWidth * 0.35));
	} else {
		return CGSizeMake(screenWidth, 44);
	}
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	if (section == 0) {
		return UIEdgeInsetsMake(10, 0, 10, 0);
	} else {
		return UIEdgeInsetsZero;
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
	if (self.viewModel.optionalViewModels.count == 0) return 1;
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		
		NSInteger totalCount = 0;
		if (self.optional) {
			totalCount = self.viewModel.optionalViewModels.count;
		} else {
			totalCount = self.viewModel.requiredViewModels.count;
		}
		
		if (totalCount % 2 != 0 && indexPath.row == totalCount) {
			MSFBlankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFBlankCell" forIndexPath:indexPath];
			return cell;
		} else {
			MSFInventoryTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFCertificateCell" forIndexPath:indexPath];
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
		MSFInventoryViewController *vc = [[MSFInventoryViewController alloc] initWithViewModel:self.viewModel];
		vc.navigationItem.title = @"更多资料";
		vc.optional = YES;
		[self.navigationController pushViewController:vc animated:YES];
	}
}

#pragma mark - storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"photosUploadSegue"]) {
		NSIndexPath *indexPath = sender;
		MSFElementViewController *vc = (MSFElementViewController *)segue.destinationViewController;
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
