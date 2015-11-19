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
		return [[self.services.httpClient fetchCirculateCash] map:^id(MSFCirculateCashModel *loan) {
			MSFHomePageCellModel *model = [[MSFHomePageCellModel alloc] initWithModel:loan services:services];
			if (model.productType == MSFProductTypeUnknown) {
				self.viewModel.active = NO;
				self.viewModel.active = YES;
				return nil;
			} else if (model.productType == MSFProductTypeMS) {
				BOOL applyBlank = [loan.type isEqualToString:@"APPLY"] && [loan.applyStatus isEqualToString:@"F"];
				BOOL contractBlank = [loan.type isEqualToString:@"CONTRACT"] && [loan.contractStatus isEqualToString:@"F"];
				if (loan.type.length == 0 || applyBlank || contractBlank) {
					self.viewModel.active = NO;
					self.viewModel.active = YES;
					return nil;
				} else {
					return model;
				}
			} else {
				return model;
			}
		}];
	}];
	[[_refreshCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
		@strongify(self)
			self.cellModel = x;
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
		if (_cellModel.productType == MSFProductTypeML && _cellModel.productType == MSFProductTypeXH && _cellModel.totalLimit.doubleValue > 0) {
			return @"MSFCirculateViewCell";
		} else {
			return @"MSFHomePageContentCollectionViewCell";
		}
	} else {
		return @"MSFHomePageContentCollectionViewCell";
	}
}

@end