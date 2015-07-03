//
// MSFHomePageViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "MSFHomepageCollectionViewHeader.h"
#import "MSFRequisitionCollectionViewCell.h"
#import "MSFPlaceholderCollectionViewCell.h"
#import "MSFPepaymentCollectionViewCell.h"
#import "MSFHomepageViewModel.h"
#import "MSFLoanViewModel.h"
#import "MSFReactiveView.h"
#import "MSFUtils.h"

@interface MSFHomepageViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UIView *separatorView;
@property(nonatomic,strong) MSFHomepageViewModel *viewModel;

@end

@implementation MSFHomepageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.collectionView.backgroundColor = [UIColor whiteColor];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  [self.collectionView registerClass:MSFHomepageCollectionViewHeader.class
   forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
  [self.collectionView registerClass:MSFRequisitionCollectionViewCell.class forCellWithReuseIdentifier:@"MSFRequisitionCollectionViewCell"];
  [self.collectionView registerClass:MSFPlaceholderCollectionViewCell.class forCellWithReuseIdentifier:@"MSFPlaceholderCollectionViewCell"];
  [self.collectionView registerClass:MSFPepaymentCollectionViewCell.class forCellWithReuseIdentifier:@"MSFPepaymentCollectionViewCell"];
  
  @weakify(self)
  self.viewModel = [[MSFHomepageViewModel alloc] initWithClient:MSFUtils.httpClient];
  [RACObserve(self.viewModel, viewModels)
    subscribeNext:^(id x) {
      @strongify(self)
      [self.collectionView reloadData];
  }];
  [[[[NSNotificationCenter defaultCenter]
    rac_addObserverForName:MSFAuthorizationDidUpdateNotification object:nil]
    takeUntil:self.rac_willDeallocSignal]
    subscribeNext:^(id x) {
      @strongify(self)
      self.viewModel = [[MSFHomepageViewModel alloc] initWithClient:MSFUtils.httpClient];
      [RACObserve(self.viewModel, viewModels) subscribeNext:^(id x) {
        @strongify(self)
        [self.collectionView reloadData];
      }];
  }];
	
	[self.collectionView addPullToRefreshWithActionHandler:^{
		@strongify(self)
		[[self.viewModel.refreshCommand
			execute:nil]
			subscribeNext:^(id x) {
				[self.collectionView.pullToRefreshView stopAnimating];
			}];
	}];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  self.viewModel.active = NO;
}

#pragma mark - UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
  CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
  CGFloat height = (width / 4.0) * 3.0;
  
  return CGSizeMake(width, height);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
    MSFHomepageCollectionViewHeader *header =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
     withReuseIdentifier:@"header" forIndexPath:indexPath];
		[header bindViewModel:self.viewModel];
		
    return header;
  }
  
  return UICollectionReusableView.new;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.viewModel numberOfItemsInSection:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
  CGFloat height = CGRectGetHeight(self.view.bounds) - (width / 4.0) * 3.0 + 10;
  
  return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MSFLoanViewModel *viewModel = [self.viewModel viewModelForIndexPath:indexPath];
  NSString *reusableIdentifier = [self.viewModel reusableIdentifierForIndexPath:indexPath];
  UICollectionViewCell <MSFReactiveView> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusableIdentifier forIndexPath:indexPath];
  if (!viewModel) {
    MSFPlaceholderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFPlaceholderCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
  }
  [cell bindViewModel:viewModel];
  
  return cell;
}

@end
