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

@property (nonatomic, strong, readwrite) NSArray *viewModels;

@end

static NSString *msf_normalUserCode    = @"0000";
static NSString *msf_msUserCode				 = @"1101";
static NSString *msf_whiteListUserCode = @"4101";

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
			NSString *userType = self.services.httpClient.user.type;
			if ([userType isEqualToString:msf_msUserCode]) {
				BOOL applyBlank = [loan.type isEqualToString:@"APPLY"] && [loan.applyStatus isEqualToString:@"F"];
				BOOL contractBlank = [loan.type isEqualToString:@"CONTRACT"] && [loan.contractStatus isEqualToString:@"F"];
				if (loan.type.length == 0 || applyBlank || contractBlank) {
					self.viewModel.active = NO;
					self.viewModel.active = YES;
					return nil;
				} else {
					MSFHomePageCellModel *viewModel = [[MSFHomePageCellModel alloc] initWithModel:loan services:services];
					return @[viewModel];
				}
			} else if ([userType isEqualToString:msf_whiteListUserCode]) {
				MSFHomePageCellModel *viewModel = [[MSFHomePageCellModel alloc] initWithModel:loan services:services];
				return @[viewModel];
			} else {
				return nil;
			}
		}];
	}];
	[[_refreshCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
		@strongify(self)
			self.viewModels = x;
	}];
	[self.refreshCommand.errors subscribeNext:^(id x) {
		@strongify(self)
		self.viewModels = nil;
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
	if (self.viewModels.count > 0) {
		return self.viewModels[0];
	} else {
		return self;
	}
}

- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath {
	if (self.viewModels.count > 0) {
		MSFHomePageCellModel *viewModel = self.viewModels[0];
		if ([self.services.httpClient.user.type isEqualToString:msf_whiteListUserCode] && viewModel.totalLimit.doubleValue > 0) {
			return @"MSFCirculateViewCell";
		} else {
			return @"MSFHomePageContentCollectionViewCell";
		}
	} else {
		return @"MSFHomePageContentCollectionViewCell";
	}
}

@end