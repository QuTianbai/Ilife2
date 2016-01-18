//
// MSFHomePageViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MSFUser.h"
#import "MSFFormsViewModel.h"
#import "MSFHomePageCellModel.h"
#import "MSFCirculateCashModel.h"
#import "MSFPersonalViewModel.h"
#import "MSFRelationshipViewModel.h"
#import "MSFProfessionalViewModel.h"

#import "MSFClient+MSFCirculateCash.h"
#import "MSFClient+Advers.h"
#import "MSFAdver.h"
#import "MSFClient+MSFOrder.h"
#import "MSFOrder.h"

@interface MSFHomepageViewModel ()

@property (nonatomic, strong) MSFFormsViewModel *viewModel;
@property (nonatomic, strong, readwrite) MSFHomePageCellModel *cellModel;
@property (nonatomic, strong, readwrite) NSArray *banners;
@property (nonatomic, assign, readwrite) BOOL hasOrders;
@property (nonatomic, strong, readwrite) NSArray *orders;

@end

@implementation MSFHomepageViewModel

- (void)dealloc {
	NSLog(@"MSFHomepageViewModel `-dealloc`");
}

- (instancetype)initWithModel:(MSFFormsViewModel *)viewModel services:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	_services = services;
	_banners = @[[[MSFAdver alloc] init]];

	@weakify(self)
	_loanInfoRefreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [[self.services.httpClient fetchCirculateCash:nil] map:^id(MSFCirculateCashModel *loan) {
			if (loan) {
				[[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGECONFIRMUPDATEMODEL" object:loan];
				return [[MSFHomePageCellModel alloc] initWithModel:loan services:services];
			} else {
				return nil;
			}
		}];
	}];
	[_loanInfoRefreshCommand.errors subscribeNext:^(id x) {
		self.cellModel = nil;
		self.viewModel.active = NO;
		self.viewModel.active = YES;
	}];
	[[_loanInfoRefreshCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
		self.cellModel = x;
		if (!x) {
			self.viewModel.active = NO;
			self.viewModel.active = YES;
		}
	}];
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		if (self.services.httpClient.user.isAuthenticated) {
			[_loanInfoRefreshCommand execute:nil];
		}
		// 获取待支付订单列表
		[[[self.services.httpClient fetchOrderList:@"3" pageNo:0]
			ignore:nil]
			subscribeNext:^(MSFOrder *order) {
				@strongify(self)
				self.orders = order.orderList;
				self.hasOrders = self.orders.count > 0;
			} error:^(NSError *error) {
				self.hasOrders = NO;
			}];
	}];
	return self;
}

#pragma mark - Public

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	return 1;
}

- (id)viewModelForIndexPath:(NSIndexPath *)indexPath {
	if (([_cellModel.productType isEqualToString:@"4101"] && [_cellModel.type isEqualToString:@"APPLY"]) || !_cellModel.productType) return self;
	return _cellModel;
}

- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath {
	if (([_cellModel.productType isEqualToString:@"4101"] && _cellModel.totalLimit.doubleValue > 0) || ([_cellModel.productType isEqualToString:@"3102"] && (_cellModel.totalLimit.doubleValue > 0 && ![_cellModel.statusString isEqualToString:@"已到期"]))) return @"MSFCirculateViewCell";
	return @"MSFHomePageContentCollectionViewCell";
}

- (void)pushInfo:(NSInteger)index {
	id viewModel = nil;
	switch (index) {
		case 0:
			viewModel = [[MSFPersonalViewModel alloc] initWithFormsViewModel:self.viewModel];
			break;
		case 1:
			viewModel = [[MSFRelationshipViewModel alloc] initWithFormsViewModel:self.viewModel];
			break;
		case 2:
			viewModel = [[MSFProfessionalViewModel alloc] initWithFormsViewModel:self.viewModel];
			break;
	}
	[self.services pushViewModel:viewModel];
}

@end