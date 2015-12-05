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

@interface MSFHomepageViewModel ()

@property (nonatomic, strong, readwrite) MSFHomePageCellModel *cellModel;

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
	
	@weakify(self)
	_refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
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
	[[_refreshCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
		@strongify(self)
		self.cellModel = x;
		if (!x) {
			self.viewModel.active = NO;
			self.viewModel.active = YES;
		}
	}];
	[self.refreshCommand.errors subscribeNext:^(id x) {
		@strongify(self)
		self.cellModel = nil;
		self.viewModel.active = NO;
		self.viewModel.active = YES;
	}];
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		if (self.services.httpClient.user.isAuthenticated) {
			[self.refreshCommand execute:nil];
		}
	}];
	return self;
}

#pragma mark - Public

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	return 1;
}

- (id)viewModelForIndexPath:(NSIndexPath *)indexPath {
	if ([_cellModel.productType isEqualToString:@"1101"]) {
		return _cellModel;
	} else if ([_cellModel.productType isEqualToString:@"4101"]) {
		if ([_cellModel.type isEqualToString:@"APPLY"]) {
			return self;
		}
		return _cellModel;
	} else if ([_cellModel.productType isEqualToString:@"4102"]) {
		return _cellModel;
	}
	return self;
}

- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath {
	if ([_cellModel.productType isEqualToString:@"1101"]) {
		return @"MSFHomePageContentCollectionViewCell";
	} else if ([_cellModel.productType isEqualToString:@"4101"]) {
		if ([_cellModel.type isEqualToString:@"APPLY"] || [_cellModel.statusString isEqualToString:@"已到期"]) {
			return @"MSFHomePageContentCollectionViewCell";
		} else if (_cellModel.totalLimit.doubleValue > 0) {
			return @"MSFCirculateViewCell";
		}
	} else if ([_cellModel.productType isEqualToString:@"4102"]) {
		if (_cellModel.totalLimit.doubleValue > 0 && ![_cellModel.statusString isEqualToString:@"已到期"]) {
			return @"MSFCirculateViewCell";
		}
	}
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