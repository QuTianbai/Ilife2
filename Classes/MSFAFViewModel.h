//
// MSFAFViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFCheckEmployee;
@class MSFApplyInfo;
@class MSFClient;
@class MSFBasicViewModel;
@class MSFAFCareerViewModel;
@class MSFAFRequestViewModel;
@class MSFRelationMemberViewModel;
@class MSFSubmitViewModel;

/**
 *  Application Form ViewModel
 */
@interface MSFAFViewModel : RVMViewModel

@property(nonatomic,strong,readonly) MSFClient *client;
@property(nonatomic,strong,readonly) MSFCheckEmployee *productSet;
@property(nonatomic,strong,readonly) MSFApplyInfo *model;
@property(nonatomic,strong,readonly) MSFCheckEmployee *market;

- (instancetype)initWithModel:(MSFApplyInfo *)model;
- (instancetype)initWithModel:(MSFApplyInfo *)model productSet:(MSFCheckEmployee *)productSet;

- (instancetype)initWithClient:(MSFClient *)client;

@property(nonatomic,strong,readonly) MSFAFRequestViewModel *requestViewModel;
@property(nonatomic,strong,readonly) MSFBasicViewModel *basicViewModel;
@property(nonatomic,strong,readonly) MSFAFCareerViewModel *professionViewModel;
@property(nonatomic,strong,readonly) MSFRelationMemberViewModel *relationViewModel;
@property(nonatomic,strong,readonly) MSFSubmitViewModel *submitViewModel;

@property(nonatomic,strong,readonly) RACSignal *updatedContentSignal;

- (RACSignal *)submitSignalWithPage:(NSInteger)page;

@end
