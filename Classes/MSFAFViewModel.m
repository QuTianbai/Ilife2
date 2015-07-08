//
// MSFAFViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAFViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "MSFUtils.h"
#import "MSFBasicViewModel.h"
#import "MSFAFCareerViewModel.h"
#import "MSFAFRequestViewModel.h"
#import "MSFRelationMemberViewModel.h"
#import "MSFSubmitViewModel.h"

#import "MSFApplyInfo.h"
#import "MSFClient+MSFApplyInfo.h"
#import "MSFClient+MSFApplyCash.h"
#import "MSFCheckEmployee.h"
#import "MSFClient+MSFCheckEmploee.h"

@interface MSFAFViewModel ()

@property(nonatomic,strong,readwrite) MSFApplyInfo *model;
@property(nonatomic,strong,readwrite) MSFCheckEmployee *market;
@property(nonatomic,strong,readwrite) RACSubject *updatedContentSignal;

@end

@implementation MSFAFViewModel

#pragma mark - Lifecycle

- (instancetype)initWithClient:(MSFClient *)client {
  self = [super init];
  if (!self) {
    return nil;
  }
	//TODO: 从这里看，退出登录需要更新，所有的控制器，所有的控制器中的ViewModel,涉及到ViewModel中的Client授权问题
	_client = client;
	_requestViwModel = [[MSFAFRequestViewModel alloc] init];
	_basicViewModel = [[MSFBasicViewModel alloc] init];
	_professionViewModel = [[MSFAFCareerViewModel alloc] init];
	_relationViewModel = [[MSFRelationMemberViewModel alloc] init];
	_submitViewModel = [[MSFSubmitViewModel alloc] init];
	
	self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"MSFAFViewModel updatedContentSignal"];
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[[self.client fetchApplyInfo]
			zipWith:[self.client fetchCheckEmployee]]
			subscribeNext:^(RACTuple *modelAndMarket) {
				RACTupleUnpack(MSFApplyInfo *model, MSFCheckEmployee *market) = modelAndMarket;
				self.model = model;
				self.market = market;
				[(RACSubject *)self.updatedContentSignal sendNext:nil];
				[(RACSubject *)self.updatedContentSignal sendCompleted];
			} error:^(NSError *error) {
				[(RACSubject *)self.updatedContentSignal sendError:error];
			}];
	}];
	
  return self;
}

- (instancetype)initWithModel:(MSFApplyInfo *)model {
  if (!(self = [super init])) {
    return nil;
  }
	_client = MSFUtils.httpClient;
  _model = model;
  
  return self;
}

- (instancetype)initWithModel:(MSFApplyInfo *)model productSet:(MSFCheckEmployee *)productSet {
  if (!(self = [super init])) {
    return nil;
  }
	_client = MSFUtils.httpClient;
  _model = model;
  _productSet = productSet;
  
  return self;
}

#pragma mark - Public

- (RACSignal *)submitSignalWithPage:(NSInteger)page {
	self.model.page = [@(page) stringValue];
	return [self.client applyInfoSubmit1:self.model];
}

@end
