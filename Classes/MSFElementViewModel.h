//
// MSFElementViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFElement;

@interface MSFElementViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSURL *thumbURL;
@property (nonatomic, assign, readonly) BOOL validity;
@property (nonatomic, assign, readonly) BOOL required;

@property (nonatomic, strong, readonly) MSFElement *model;

// MSAttachmentViewModel instances
@property (nonatomic, strong, readonly) NSArray *viewModels;

- (instancetype)initWithModel:(id)model services:(id <MSFViewModelServices>)services;

@end
