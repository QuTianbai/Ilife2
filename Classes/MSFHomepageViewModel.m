//
// MSFHomePageViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFClient+Users.h"
#import "MSFClient+Repayment.h"
#import "MSFResponse.h"
#import "MSFLoanViewModel.h"
#import "MSFRepaymentViewModel.h"
#import "MSFBannersViewModel.h"
#import "MSFApplyList.h"



@interface MSFHomepageViewModel ()

@property (nonatomic, readwrite) NSArray *viewModels;
@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

@implementation MSFHomepageViewModel

- (void)dealloc {
	NSLog(@"MSFHomepageViewModel `-dealloc`");
}

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_bannersViewModel = [[MSFBannersViewModel alloc] initWithServices:self.services];
	
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
				MSFApplyList *applyList = [MSFApplyList modelWithDictionary:value.parsedResult[@"data"] error:nil];
				MSFLoanViewModel *viewModel = [[MSFLoanViewModel alloc] initWithModel:applyList];
				return [RACSignal return:@[viewModel]];
			} else {
				return [[self.services.httpClient fetchRepayment] map:^id(id value) {
					MSFRepaymentViewModel *viewModel = [[MSFRepaymentViewModel alloc] initWithModel:value];
					return @[viewModel];
				}];
			}
		}];
	}];
	
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.refreshCommand execute:nil];
	}];
	
	RAC(self, viewModels) = [[self.refreshCommand.executionSignals switchToLatest] ignore:nil];
	[self.refreshCommand.errors subscribeNext:^(id x) {
		@strongify(self)
		self.viewModels = nil;
	}];
	
	return self;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	return self.viewModels.count == 0 ? 1 : self.viewModels.count;
}

- (MSFLoanViewModel *)viewModelForIndexPath:(NSIndexPath *)indexPath {
	if (self.viewModels.count > indexPath.item) {
		return self.viewModels[indexPath.item];
	}
	
	return nil;
}

- (NSString *)reusableIdentifierForIndexPath:(NSIndexPath *)indexPath {
	return @"MSFHomePageContentCollectionViewCell";
}

@end