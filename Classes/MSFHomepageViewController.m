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
#import "MSFCirculateViewCell.h"

#import "MSFHomepageViewModel.h"
#import "MSFReactiveView.h"
#import "MSFOrderListViewController.h"

@interface MSFHomepageViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, readwrite) MSFHomepageViewModel *viewModel;

@end

@implementation MSFHomepageViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(MSFHomepageViewModel *)viewModel {
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	self = [super initWithCollectionViewLayout:flowLayout];
	if (self) {
		_viewModel = viewModel;
		self.collectionView.backgroundColor = [UIColor whiteColor];
		self.edgesForExtendedLayout = UIRectEdgeNone;
		self.collectionView.allowsSelection = NO;
		[self.collectionView registerClass:MSFHomepageCollectionViewHeader.class
						forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
		[self.collectionView registerClass:MSFHomePageContentCollectionViewCell.class forCellWithReuseIdentifier:@"MSFHomePageContentCollectionViewCell"];
		[self.collectionView registerClass:MSFCirculateViewCell.class forCellWithReuseIdentifier:@"MSFCirculateViewCell"];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	@weakify(self)
	[[RACSignal combineLatest:@[RACObserve(self, viewModel.cellModel), RACObserve(self, viewModel.banners)]] subscribeNext:^(id x) {
		[self.collectionView reloadData];
	}];
	[[self.viewModel.loanInfoRefreshCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
		[self.collectionView.pullToRefreshView stopAnimating];
	} error:^(NSError *error) {
		[self.collectionView.pullToRefreshView stopAnimating];
	}];
	[self.collectionView addPullToRefreshWithActionHandler:^{
		@strongify(self)
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFREQUESTCONTRACTSNOTIFACATION" object:nil];
		self.viewModel.active = NO;
		self.viewModel.active = YES;
	}];
	[[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.active = NO;
		self.viewModel.active = YES;
	}];
	
	UIBarButtonItem *scanItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:nil action:nil];
	UIBarButtonItem *payItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:nil action:nil];
	[RACObserve(self, viewModel.hasOrders) subscribeNext:^(id x) {
		@strongify(self)
		if ([x boolValue]) {
			self.navigationItem.rightBarButtonItems = @[scanItem, payItem];
		} else {
			self.navigationItem.rightBarButtonItems = @[scanItem];
		}
	}];
	
	payItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		MSFOrderListViewController *vc = [[MSFOrderListViewController alloc] initWithServices:self.viewModel.services];
		[self.navigationController pushViewController:vc animated:YES];
		return RACSignal.empty;
	}];
	scanItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return RACSignal.empty;
	}];
}

#pragma mark - UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);
	CGFloat height = width / 2.16;
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
	CGFloat height = CGRectGetHeight(UIScreen.mainScreen.bounds) - width / 2.16 - 112.5;
	return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	id viewModel = [self.viewModel viewModelForIndexPath:indexPath];
	NSString *reusableIdentifier = [self.viewModel reusableIdentifierForIndexPath:indexPath];
	UICollectionViewCell <MSFReactiveView> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusableIdentifier forIndexPath:indexPath];
	[cell bindViewModel:viewModel];
	return cell;
}

@end
