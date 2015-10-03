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

#import "MSFClient+Users.h"
#import "MSFClient+Repayment.h"
#import "MSFClient+MSFApplyInfo.h"

@interface MSFHomepageViewModel ()

@property (nonatomic, readwrite) NSArray *viewModels;
@property (nonatomic, weak) id <MSFViewModelServices> services;

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
	_bannersViewModel = [[MSFBannersViewModel alloc] initWithServices:self.services];
	_circulateCashViewModel = [[MSFCirculateCashViewModel alloc] initWithServices:services];
	
	@weakify(self)
	_refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		self.bannersViewModel.active = NO;
		self.bannersViewModel.active = YES;
		if (!self.services.httpClient.isAuthenticated) {
			return [RACSignal return:nil];
		}
		return [[self.services.httpClient checkUserHasCredit] flattenMap:^RACStream *(MSFResponse *value) {
			if ([value.parsedResult[@"processing"] boolValue]) {
				MSFApplyList *applyList = [MTLJSONAdapter modelOfClass:MSFApplyList.class fromJSONDictionary:value.parsedResult[@"data"] error:nil];
				MSFLoanViewModel *viewModel = [[MSFLoanViewModel alloc] initWithModel:applyList services:services];
				return [RACSignal return:@[viewModel]];
			} else {
				return [[self.services.httpClient fetchRepayment] map:^id(id value) {
					MSFRepaymentViewModel *viewModel = [[MSFRepaymentViewModel alloc] initWithModel:value services:services];
					return @[viewModel];
				}];
			}
		}];
	}];
	
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		if (self.services.httpClient.user.isAuthenticated) {
			if (self.services.httpClient.user.type.integerValue == 0) {
				[self.refreshCommand execute:nil];
			} else {
				self.circulateCashViewModel.active = NO;
				self.circulateCashViewModel.active = YES;
			}
		}
	}];
	
	RAC(self, viewModels) = [[self.refreshCommand.executionSignals switchToLatest] ignore:nil];
	[self.refreshCommand.errors subscribeNext:^(id x) {
		@strongify(self)
		self.viewModels = nil;
		self.viewModel.active = NO;
		self.viewModel.active = YES;
	}];
	
	return self;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	//return self.viewModels.count == 0 ? 1 : self.viewModels.count;
	return 1;
}

- (id)viewModelForIndexPath:(NSIndexPath *)indexPath {
	if (self.services.httpClient.user.type.integerValue == 0) {
		if (self.viewModels.count > indexPath.item) {
			return self.viewModels[indexPath.item];
		}
	} else {
		return self.circulateCashViewModel;
	}

	return nil;
}

- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath {
	if (self.services.httpClient.user.type.integerValue == 0) {
		return @"MSFHomePageContentCollectionViewCell";
	} else {
		return @"MSFCirculateViewCell";
	}
}

@end