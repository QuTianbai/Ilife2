//
// MSFCouponsViewModel.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class RACCommand;

@interface MSFCouponsViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) NSArray *viewModels;

@property (nonatomic, strong, readonly) RACCommand *executeFetchCommand;
@property (nonatomic, strong, readonly) RACCommand *executeAdditionCommand;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
