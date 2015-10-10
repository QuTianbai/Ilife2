//
//	MSFPersonalViewModel.h
//	Cash
//
//	Created by xutian on 15/6/13.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class MSFFormsViewModel;
@class RACCommand;

@interface MSFRelationshipViewModel : RVMViewModel

@property (nonatomic, readonly) MSFFormsViewModel *formsViewModel;
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel;

@end
