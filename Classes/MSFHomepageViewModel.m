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

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	return 1;
}

- (id)viewModelForIndexPath:(NSIndexPath *)indexPath {
	return self.cellModel ?: self;
}

- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath {
	if (_cellModel) {
		if (([_cellModel.productType isEqualToString:@"4102"] || [_cellModel.productType isEqualToString:@"4101"]) && _cellModel.totalLimit.doubleValue > 0) {
			return @"MSFCirculateViewCell";
		} else {
			return @"MSFHomePageContentCollectionViewCell";
		}
	} else {
		return @"MSFHomePageContentCollectionViewCell";
	}
}

@end