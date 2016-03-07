//
// MSFContactViewModel.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFContact;

@interface MSFContactViewModel : RVMViewModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) BOOL on;
@property (nonatomic, copy, readonly) NSString *relationship;
@property (nonatomic, strong, readonly) MSFContact *model;

@property (nonatomic, strong, readonly) RACCommand *executeRelationshipCommand;
@property (nonatomic, strong, readonly) RACCommand *executeSelectContactCommand;

- (instancetype)initWithModel:(id)model Services:(id <MSFViewModelServices>)services;

@end
