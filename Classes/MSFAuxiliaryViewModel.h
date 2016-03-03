//
// MSFAuxiliaryViewModel.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class RACCommand;

@interface MSFAuxiliaryViewModel : RVMViewModel

@property (nonatomic, copy, readonly) NSString *qq;
@property (nonatomic, copy, readonly) NSString *qqpwd;

@property (nonatomic, copy, readonly) NSString *taobao;
@property (nonatomic, copy, readonly) NSString *taobaopwd;

@property (nonatomic, copy, readonly) NSString *jd;
@property (nonatomic, copy, readonly) NSString *jdpwd;

@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
