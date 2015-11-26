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

// 附件类型
@interface MSFElementViewModel : RVMViewModel

// 类型名称
@property (nonatomic, strong, readonly) NSString *name;

// 类型标题
@property (nonatomic, strong, readonly) NSString *title;

// 类型缩略图地址
@property (nonatomic, strong, readonly) NSURL *thumbURL;

// 类型示例图地址
@property (nonatomic, strong, readonly) NSURL *sampleURL;

// 判断当前元素附件是否已经添加
@property (nonatomic, assign, readonly) BOOL isCompleted;

// 判断当前元素是否为必选
@property (nonatomic, assign, readonly) BOOL isRequired;

// 当前元素
@property (nonatomic, strong, readonly) MSFElement *element;

// 附件集合 <MSFAttachment>
@property (nonatomic, strong, readonly) NSArray *attachments;

// MSAttachmentViewModel instances
@property (nonatomic, strong, readonly) NSArray *viewModels;

// 上传命令，上传类型下所有的附件
@property (nonatomic, strong, readonly) RACCommand *uploadCommand;

// 附件附件类型ViewModel
//
// model - 附件类型对象<MSFElement>
// services - <MSFViewModelServices>
//
// Returns a <MSFElementViewModel> instance
- (instancetype)initWithElement:(id)model services:(id <MSFViewModelServices>)services;

// 添加附件到类型中
//
// attachment - 附件 <MSAttachment>
- (void)addAttachment:(MSFAttachment *)attachment;

// 从类型中删除附件
//
// attachment - 附件 <MSAttachment>
- (void)removeAttachment:(MSFAttachment *)attachment;

@end
