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
#import "MSFCirculateCashModel.h"
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
			
			return [RACSignal combineLatest:@[[self.services.httpClient fetchCheckAllowApply], [self.services.httpClient fetchCirculateCash]] reduce:^id(MSFCheckAllowApply *allow, MSFCirculateCashModel *loan){
				if ([loan.produceType isEqualToString:@"MS"]) {
					NSLog(@"productType: 马上贷产品");
				}
				BOOL applyBlank = [loan.type isEqualToString:@"APPLY"] && [loan.applyStatus isEqualToString:@"F"];
				BOOL contractBlank = [loan.type isEqualToString:@"CONTRACT"] && [loan.contractStatus isEqualToString:@"F"];
				if (loan.type.length == 0 || applyBlank || contractBlank) {
					self.viewModel.active = NO;
					self.viewModel.active = YES;
					return nil;
				} else {
					MSFLoanViewModel *viewModel = [[MSFLoanViewModel alloc] initWithModel:loan services:services];
					return @[viewModel];
				}
			}];
		} else if ([self.services.httpClient.user.type isEqualToString:msf_whiteListUserCode]) {
			self.circulateCashViewModel.active = NO;
			self.circulateCashViewModel.active = YES;
		}
		return [RACSignal return:nil];
	}];
	[[_refreshCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
		@strongify(self)
		if ([self.services.httpClient.user.type isEqualToString:msf_normalUserCode]) {
			self.viewModels = x;
		}
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
	if ([self.services.httpClient.user.type isEqualToString:msf_normalUserCode]) {
		if (self.viewModels.count > 0) {
			return self.viewModels[0];
		} else {
			return self;
		}
	} else if ([self.services.httpClient.user.type isEqualToString:msf_whiteListUserCode] && self.circulateCashViewModel.totalLimit.doubleValue > 0) {
		return self.circulateCashViewModel;
	} else {
		return self;
	}
}

- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath {
	if ([self.services.httpClient.user.type isEqualToString:msf_whiteListUserCode] && self.circulateCashViewModel.totalLimit.doubleValue > 0) {
		return @"MSFCirculateViewCell";
	} else {
		return @"MSFHomePageContentCollectionViewCell";
	}
}

@end