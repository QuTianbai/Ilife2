//
// MSFFormsViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFFormsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "MSFUtils.h"
#import "MSFPersonalViewModel.h"
#import "MSFProfessionalViewModel.h"
#import "MSFProductViewModel.h"
#import "MSFRelationshipViewModel.h"

#import "MSFApplicationForms.h"
#import "MSFClient+MSFApplyInfo.h"
#import "MSFClient+MSFApplyCash.h"
#import "MSFClient+Users.h"
#import "MSFMarket.h"
#import "MSFClient+MSFCheckEmploee.h"
#import "MSFResponse.h"
#import "MSFAddress.h"

@interface MSFFormsViewModel ()

@property (nonatomic, strong, readwrite) RACSubject *updatedContentSignal;
@property (nonatomic, strong, readwrite) MSFApplicationForms *model;
@property (nonatomic, strong, readwrite) MSFMarket *market;
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
	_market = [[MSFMarket alloc] init];
	_currentAddress = [[MSFAddress alloc] init];
	_workAddress = [[MSFAddress alloc] init];

	self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"MSFAFViewModel updatedContentSignal"];
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[[[self.services.httpClient fetchApplyInfo]
			zipWith:[self.services.httpClient fetchCheckEmployee]]
			flattenMap:^RACStream *(RACTuple *modelAndMarket) {
				RACTupleUnpack(MSFApplicationForms *model, MSFMarket *market) = modelAndMarket;
				[self.model mergeValuesForKeysFromModel:model];
				[self.market mergeValuesForKeysFromModel:market];
        self.isHaveProduct = YES;
				[self.currentAddress mergeValuesForKeysFromModel:[[MSFAddress alloc] initWithDictionary:@{
					@"province": self.model.currentProvinceCode,
					@"city": self.model.currentCityCode,
					@"area": self.model.currentCountryCode,
				} error:nil]];
				[self.workAddress mergeValuesForKeysFromModel: [[MSFAddress alloc] initWithDictionary:@{
					@"province": self.model.workProvinceCode,
					@"city": self.model.workCityCode,
					@"area": self.model.workCountryCode,
				} error:nil]];
				return [self.services.httpClient checkUserHasCredit];
			}]
			subscribeNext:^(MSFResponse *response) {
				self.pending = [response.parsedResult[@"processing"] boolValue];
				[(RACSubject *)self.updatedContentSignal sendNext:nil];
				[(RACSubject *)self.updatedContentSignal sendCompleted];
			} error:^(NSError *error) {
        self.isHaveProduct = NO;
				[(RACSubject *)self.updatedContentSignal sendError:error];
			}];
	}];
	
	return self;
}

#pragma mark - Public

- (RACSignal *)submitSignalWithPage:(NSInteger)page {
	self.model.page = [@(page) stringValue];
	return [self.services.httpClient applyInfoSubmit1:self.model];
}

@end
