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

@class MSFApplicationForms;
@class RACCommand;

__attribute__((deprecated("This class is unavailable. Please use the MSFProfessionalViewController class instead")))

@interface MSFRelationshipViewModel : RVMViewModel <MSFReactiveView>

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) MSFApplicationForms *forms;
@property (nonatomic, strong, readonly) NSString *fullAddress;
@property (nonatomic, assign, readonly) BOOL edited;

@property (nonatomic, strong, readonly) RACCommand *executeMarriageCommand;
@property (nonatomic, strong, readonly) RACCommand *executeContactBookCommand;
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;

@end
