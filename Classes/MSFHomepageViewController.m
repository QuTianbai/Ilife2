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
#import "MSFLoanViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFReactiveView.h"
#import "MSFUtils.h"
#import "UIColor+Utils.h"
#import "MSFAboutsViewController.h"
#import "MSFClient.h"
#import "MSFUser.h"

#import "MSFClient+RepaymentSchedules.h"
#import "MSFClient+ApplyList.h"
#import "MSFUtils.h"

@interface MSFHomepageViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

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
	self.collectionView.allowsSelection = NO;
	[self.collectionView registerClass:MSFHomepageCollectionViewHeader.class
	 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
	[self.collectionView registerNib:[UINib nibWithNibName:@"MSFHomePageContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MSFHomePageContentCollectionViewCell"];
	[self.collectionView registerNib:[UINib nibWithNibName:@"MSFCirculateViewCell" bundle:nil] forCellWithReuseIdentifier:@"MSFCirculateViewCell"];
	
	@weakify(self)
	[RACObserve(self.viewModel, viewModels) subscribeNext:^(id x) {
		@strongify(self)
		[self.collectionView reloadData];
	}];
	[RACObserve(MSFUtils.httpClient.user, complateCustInfo) subscribeNext:^(id x) {
		@strongify(self)
		[self.collectionView reloadData];
	}];
	
	[self.collectionView addPullToRefreshWithActionHandler:^{
		@strongify(self)
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFREQUESTCONTRACTSNOTIFACATION" object:nil];
		[[self.viewModel.refreshCommand
			execute:nil]
			subscribeNext:^(id x) {
				[self.collectionView.pullToRefreshView stopAnimating];
			} error:^(NSError *error) {
				[self.collectionView.pullToRefreshView stopAnimating];
			}];
	}];
	
	[[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.active = NO;
		self.viewModel.active = YES;
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
