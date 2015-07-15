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

@interface MSFFormsViewModel ()

@property(nonatomic,strong,readwrite) RACSubject *updatedContentSignal;
@property(nonatomic,strong,readwrite) MSFApplicationForms *model;
@property(nonatomic,strong,readwrite) MSFMarket *market;
@property(nonatomic,assign,readwrite) BOOL pending;

@end

@implementation MSFFormsViewModel

#pragma mark - Lifecycle

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}
	_model = [[MSFApplicationForms alloc] init];
	_market = [[MSFMarket alloc] init];
	_pending = NO;

	self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"MSFAFViewModel updatedContentSignal"];
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[[[self.client fetchApplyInfo]
			zipWith:[self.client fetchCheckEmployee]]
			flattenMap:^RACStream *(RACTuple *modelAndMarket) {
				RACTupleUnpack(MSFApplicationForms *model, MSFMarket *market) = modelAndMarket;
				self.model = model;
				self.market = market;
				return [self.client checkUserHasCredit];
			}]
			subscribeNext:^(MSFResponse *response) {
				self.pending = [response.parsedResult[@"processing"] boolValue];
				[(RACSubject *)self.updatedContentSignal sendNext:nil];
				[(RACSubject *)self.updatedContentSignal sendCompleted];
			} error:^(NSError *error) {
				[(RACSubject *)self.updatedContentSignal sendError:error];
			}];
	}];
	
	return self;
}

#pragma mark - Public

- (RACSignal *)submitSignalWithPage:(NSInteger)page {
	self.model.page = [@(page) stringValue];
	return [self.client applyInfoSubmit1:self.model];
}

#pragma mark - Private

- (MSFClient *)client {
	return MSFUtils.httpClient;
}

@end
