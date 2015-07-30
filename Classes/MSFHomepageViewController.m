//
// MSFHomePageViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "MSFHomepageCollectionViewHeader.h"
#import "MSFHomePageContentCollectionViewCell.h"
#import "MSFPlaceholderCollectionViewCell.h"
#import "MSFHomepageViewModel.h"
#import "MSFLoanViewModel.h"
#import "MSFReactiveView.h"
#import "MSFUtils.h"
#import "UIColor+Utils.h"
#import "MSFSettingsViewController.h"

@interface MSFHomepageViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong, readwrite) MSFHomepageViewModel *viewModel;

@end

@implementation MSFHomepageViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(MSFHomepageViewModel *)viewModel {
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  self = [super initWithCollectionViewLayout:flowLayout];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
	label.text = @"马上贷";
	label.textColor = [UIColor tintColor];
	label.font = [UIFont boldSystemFontOfSize:17];
	label.textAlignment = NSTextAlignmentCenter;
	self.navigationItem.titleView = label;
	self.collectionView.backgroundColor = [UIColor whiteColor];
	self.edgesForExtendedLayout = UIRectEdgeNone;
	[self.collectionView registerClass:MSFHomepageCollectionViewHeader.class
	 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
	[self.collectionView registerNib:[UINib nibWithNibName:@"MSFHomePageContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MSFHomePageContentCollectionViewCell"];
	[self.collectionView registerClass:MSFPlaceholderCollectionViewCell.class forCellWithReuseIdentifier:@"MSFPlaceholderCollectionViewCell"];
	
	@weakify(self)
	[RACObserve(self.viewModel, viewModels) subscribeNext:^(id x) {
		@strongify(self)
		[self.collectionView reloadData];
	}];
	
	[self.collectionView addPullToRefreshWithActionHandler:^{
		@strongify(self)
		[[self.viewModel.refreshCommand
			execute:nil]
			subscribeNext:^(id x) {
				[self.collectionView.pullToRefreshView stopAnimating];
			}];
	}];
	self.navigationItem.rightBarButtonItem =
		[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-setting"]
		style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.rightBarButtonItem.rac_command =
		[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			@strongify(self)
			MSFSettingsViewController *settingsViewController = [[MSFSettingsViewController alloc] init];
			settingsViewController.hidesBottomBarWhenPushed = YES;
			[self.navigationController pushViewController:settingsViewController animated:YES];
			return [RACSignal empty];
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
	CGFloat height = width / 2;
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
	CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds) - width / 2.0 - 112.5;
	return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	MSFLoanViewModel *viewModel = [self.viewModel viewModelForIndexPath:indexPath];
	NSString *reusableIdentifier = [self.viewModel reusableIdentifierForIndexPath:indexPath];
	UICollectionViewCell <MSFReactiveView> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusableIdentifier forIndexPath:indexPath];
	if (viewModel) [cell bindViewModel:viewModel];
	return cell;
}

@end
