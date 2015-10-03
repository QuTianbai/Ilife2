//
// MSFElementViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFElement;
@class MSFAttachment;

@interface MSFElementViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSURL *thumbURL;
@property (nonatomic, strong, readonly) NSURL *sampleURL;

// 判断当前元素附件是否已经添加
@property (nonatomic, assign, readonly) BOOL isCompleted;
@property (nonatomic, assign, readonly) BOOL isRequired;

@property (nonatomic, strong, readonly) MSFElement *element;

// MSAttachmentViewModel instances
@property (nonatomic, strong, readonly) NSArray *attachments;
@property (nonatomic, strong, readonly) NSArray *viewModels;

@property (nonatomic, strong, readonly) RACCommand *uploadCommand;

- (instancetype)initWithElement:(id)model services:(id <MSFViewModelServices>)services;

- (void)addAttachment:(MSFAttachment *)attachment;
- (void)removeAttachment:(MSFAttachment *)attachment;

@end
