//
// MSFFormsViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFFormsViewModel.h"
#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MSFUtils.h"
#import "MSFPersonalViewModel.h"
#import "MSFProfessionalViewModel.h"
#import "MSFRelationshipViewModel.h"

#import "MSFApplicationForms.h"
#import "MSFClient+MSFApplyInfo.h"
#import "MSFClient+MSFApplyCash.h"
#import "MSFClient+Users.h"
#import "MSFMarket.h"
#import "MSFClient+MSFCheckEmploee.h"
#import "MSFResponse.h"
#import "MSFAddress.h"

#import "MSFMarkets.h"
#import "MSFClient+MSFCheckEmploee2.h"

@interface MSFFormsViewModel ()

@property (nonatomic, strong, readwrite) RACSubject *updatedContentSignal;
@property (nonatomic, strong, readwrite) MSFApplicationForms *model;
@property (nonatomic, strong, readwrite) MSFMarket *market;
@property (nonatomic, strong, readwrite) MSFMarkets *markets;
@property (nonatomic, strong, readwrite) MSFAddress *currentAddress;
@property (nonatomic, strong, readwrite) MSFAddress *workAddress;
@property (nonatomic, assign, readwrite) BOOL pending;
@property (nonatomic, weak, readwrite) id <MSFViewModelServices> services;

@end

@implementation MSFFormsViewModel

#pragma mark - Lifecycle

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_pending = NO;
	_services = services;
	_model = [[MSFApplicationForms alloc] init];
	//_market = [[MSFMarket alloc] init];
	_markets = [[MSFMarkets alloc] init];
	_currentAddress = [[MSFAddress alloc] init];
	_workAddress = [[MSFAddress alloc] init];

	self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"MSFAFViewModel updatedContentSignal"];
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[self.services.httpClient fetchCheckEmploeeWithProductCode:MSFUtils.productCode] subscribeNext:^(id x) {
			self.markets = x;
		}];
		[[self.services.httpClient fetchApplyInfo]
		 subscribeNext:^(id x) {
			self.model = x;
		}];
	}];
//	[self.didBecomeActiveSignal subscribeNext:^(id x) {
//		@strongify(self)
//		[[[[self.services.httpClient fetchApplyInfo]
//			zipWith:[self.services.httpClient fetchCheckEmployee]]
//			flattenMap:^RACStream *(RACTuple *modelAndMarket) {
//				RACTupleUnpack(MSFApplicationForms *model, MSFMarket *market) = modelAndMarket;
//				[self.model mergeValuesForKeysFromModel:model];
//				[self.market mergeValuesForKeysFromModel:market];
//        self.isHaveProduct = YES;
//				return [self.services.httpClient checkUserHasCredit];
//			}]
//			subscribeNext:^(MSFResponse *response) {
//				self.pending = [response.parsedResult[@"processing"] boolValue];
//				[(RACSubject *)self.updatedContentSignal sendNext:nil];
//				[(RACSubject *)self.updatedContentSignal sendCompleted];
//			} error:^(NSError *error) {
//        self.isHaveProduct = NO;
//				self.active = NO;
//				[(RACSubject *)self.updatedContentSignal sendError:error];
//			}];
//	}];
	
//	RAC(self.currentAddress, province) = RACObserve(self.model, currentProvinceCode);
//	RAC(self.currentAddress, city) = RACObserve(self.model, currentCityCode);
//	RAC(self.currentAddress, area) = RACObserve(self.model, currentCountryCode);
//	RAC(self.workAddress, province) = RACObserve(self.model, workProvinceCode);
//	RAC(self.workAddress, city) = RACObserve(self.model, workCityCode);
//	RAC(self.workAddress, area) = RACObserve(self.model, workCountryCode);
	
	return self;
}

#pragma mark - Public

- (RACSignal *)submitUserInfo {
	return [self.services.httpClient submitUserInfo:self.model];
}

- (RACSignal *)submitSignalWithPage:(NSInteger)page {
	self.model.page = [@(page) stringValue];
	if (page == 5) {
		self.model.applyStatus1 = @"1";
	} else {
		self.model.applyStatus1 = @"0";
	}
	return [[self.services.httpClient applyInfoSubmit1:self.model] doNext:^(id x) {
		if (page == 5) self.pending = YES;
	}];
}

@end
