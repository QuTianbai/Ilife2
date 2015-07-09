//
// MSFFormsViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFFormsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "MSFUtils.h"
#import "MSFBasicViewModel.h"
#import "MSFAFCareerViewModel.h"
#import "MSFProductViewModel.h"
#import "MSFRelationMemberViewModel.h"
#import "MSFSubmitViewModel.h"

#import "MSFApplyInfo.h"
#import "MSFClient+MSFApplyInfo.h"
#import "MSFClient+MSFApplyCash.h"
#import "MSFCheckEmployee.h"
#import "MSFClient+MSFCheckEmploee.h"

@interface MSFFormsViewModel ()

@property(nonatomic,strong,readwrite) RACSubject *updatedContentSignal;

@end

@implementation MSFFormsViewModel

#pragma mark - Lifecycle

- (instancetype)initWithClient:(MSFClient *)client {
  self = [super init];
  if (!self) {
    return nil;
  }
	//TODO: 从这里看，退出登录需要更新，所有的控制器，所有的控制器中的ViewModel,涉及到ViewModel中的Client授权问题
	_client = client;
	_model = [[MSFApplyInfo alloc] init];
	_market = [[MSFCheckEmployee alloc] init];

	self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"MSFAFViewModel updatedContentSignal"];
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[[self.client fetchApplyInfo]
			zipWith:[self.client fetchCheckEmployee]]
			subscribeNext:^(RACTuple *modelAndMarket) {
				RACTupleUnpack(MSFApplyInfo *model, MSFCheckEmployee *market) = modelAndMarket;
				[self.model mergeValuesForKeysFromModel:model];
				[self.market mergeValuesForKeysFromModel:market];
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

@end
