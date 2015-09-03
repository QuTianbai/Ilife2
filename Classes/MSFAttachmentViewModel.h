//
// MSFAttachmentViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFAttachment;

@interface MSFAttachmentViewModel : RVMViewModel

@property (nonatomic, strong, readonly) MSFAttachment *attachment;
@property (nonatomic, strong, readonly) NSURL *thumbURL;
@property (nonatomic, strong, readonly) NSURL *fileURL;
@property (nonatomic, assign, readonly) BOOL isUploaded;
@property (nonatomic, assign, readonly) BOOL removeEnabled;

@property (nonatomic, strong, readonly) RACCommand *takePhotoCommand;
@property (nonatomic, strong, readonly) RACCommand *removeCommand;
@property (nonatomic, strong, readonly) RACCommand *uploadAttachmentCommand;
@property (nonatomic, strong, readonly) RACCommand *downloadAttachmentCommand;

- (RACSignal *)takePhotoValidSignal;
- (RACSignal *)uploadValidSignal;
- (RACSignal *)downloadValidSignal;

- (instancetype)initWthAttachment:(MSFAttachment *)attachment services:(id <MSFViewModelServices>)services;

@end
