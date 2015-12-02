//
//	MSFPersonalViewModel.h
//	Cash
//
//	Created by xutian on 15/6/13.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "ReactiveViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFReactiveView.h"

@class MSFFormsViewModel;
@class RACCommand;

@interface MSFRelationshipViewModel : RVMViewModel<MSFReactiveView>

@property (nonatomic, readonly) MSFFormsViewModel *formsViewModel;
@property (nonatomic, strong, readonly) RACCommand *executeMarriageCommand;
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

@end
