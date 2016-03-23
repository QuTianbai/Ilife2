//
// MSFWebViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@interface MSFWebViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services type:(NSString *)agreementType;

- (RACSignal *)HTMLSignal;

@end
