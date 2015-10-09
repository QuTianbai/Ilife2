//
// MSFHomePageViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MSFUser.h"
#import "MSFResponse.h"
#import "MSFApplyList.h"

#import "MSFLoanViewModel.h"
#import "MSFRepaymentViewModel.h"
#import "MSFBannersViewModel.h"
#import "MSFCirculateCashViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFCheckAllowApply.h"
#import "MSFApplyCashInfo.h"

#import "MSFClient+Users.h"
#import "MSFClient+Repayment.h"
#import "MSFClient+MSFApplyInfo.h"
#import "MSFClient+MSFCheckAllowApply.h"
#import "MSFClient+MSFCirculateCash.h"

@interface MSFHomepageViewModel ()

@property (nonatomic, readwrite) NSArray *viewModels;
@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

static NSString *msf_normalUserCode = @"1101";
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
	_circulateCashViewModel = [[MSFCirculateCashViewModel alloc] initWithServices:services];
	
	@weakify(self)
	_refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		if ([self.services.httpClient.user.type isEqualToString:msf_normalUserCode]) {
			return [[self.services.httpClient fetchCheckAllowApply] flattenMap:^RACStream *(MSFCheckAllowApply *value) {
				if (value.processing) {
					return [RACSignal return:nil];
				} else {
					if (value.data) {
						MSFLoanViewModel *viewModel = [[MSFLoanViewModel alloc] initWithModel:value.data services:services];
						return [RACSignal return:@[viewModel]];
					} else {
						return [[self.services.httpClient fetchCirculateCash] map:^id(id value) {
							MSFLoanViewModel *viewModel = [[MSFLoanViewModel alloc] initWithModel:value services:services];
							return @[viewModel];
						}];
					}
				}
			}];
		}
		return [RACSignal return:nil];
	}];
	[[_refreshCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModels = x;
	}];
	[self.refreshCommand.errors subscribeNext:^(id x) {
		@strongify(self)
		self.viewModels = nil;
	}];
	
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		if (self.services.httpClient.user.isAuthenticated) {
			if ([self.services.httpClient.user.type isEqualToString:msf_normalUserCode]) {
				[self.refreshCommand execute:nil];
				self.viewModel.active = NO;
				self.viewModel.active = YES;
			} else if ([self.services.httpClient.user.type isEqualToString:msf_whiteListUserCode]) {
				self.circulateCashViewModel.active = NO;
				self.circulateCashViewModel.active = YES;
			}
		}
	}];
	
	return self;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	return 1;
}

- (id)viewModelForIndexPath:(NSIndexPath *)indexPath {
	if ([self.services.httpClient.user.type isEqualToString:msf_normalUserCode]) {
		if (self.viewModels.count > 0) {
			return self.viewModels[0];
		} else {
			return nil;
		}
	} else if ([self.services.httpClient.user.type isEqualToString:msf_whiteListUserCode]) {
		return self.circulateCashViewModel;
	} else {
		return nil;
	}
}

- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath {
	if ([self.services.httpClient.user.type isEqualToString:msf_whiteListUserCode]) {
		return @"MSFCirculateViewCell";
	} else {
		return @"MSFHomePageContentCollectionViewCell";
	}
}

@end