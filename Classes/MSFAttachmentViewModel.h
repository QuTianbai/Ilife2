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

// 附件信息
//
// 类型1 占为附件, isPlaceholder is YES
// 类型2 通过服务器获取的json解析附件，本地不存在附件图片文件, 存在objectID
// 类型3 本地创建附件对象，没有objectID
@property (nonatomic, strong, readonly) MSFAttachment *attachment;

// 附件缩略图地址
@property (nonatomic, strong, readonly) NSURL *thumbURL;

// 判断附件是否可以删除，用于区分占为附件
// Can't remove from elementViewModel's viewModels
@property (nonatomic, assign, readonly) BOOL removeEnabled;

// 判断附件是否已经上传到服务器，通过附件是否存在objectID判断
@property (nonatomic, assign, readonly) BOOL isUploaded;

// Cell上点击删除按钮执行删除命令，通知ElementViewModel删除此viewModel
@property (nonatomic, strong, readonly) RACCommand *removeCommand;

// 拍照，调用相机/相册获取图片
@property (nonatomic, strong, readonly) RACCommand *takePhotoCommand;

// 上传， 上传本地附件图片文件到服务器
@property (nonatomic, strong, readonly) RACCommand *uploadAttachmentCommand;

// 创建新的viewModel
//
// attachment - model控制的附件对象
// services - 调用相机，以及上传用到的服务
//
// return 新的附件ViewModel
- (instancetype)initWithModel:(MSFAttachment *)model services:(id <MSFViewModelServices>)services;

@end

