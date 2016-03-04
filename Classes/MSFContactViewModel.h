//
// MSFContactViewModel.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class RACCommand;

@interface MSFContactViewModel : RVMViewModel

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *phone;
@property (nonatomic, copy, readonly) NSString *relationship;
@property (nonatomic, copy, readonly) NSString *adress;

@property (nonatomic, strong, readonly) RACCommand *executeRelationshipCommand;

- (instancetype)initWithModel:(id)model Services:(id <MSFViewModelServices>)services;

@end
