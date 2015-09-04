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

// 附件图片文件地址
@property (nonatomic, strong, readonly) NSURL *fileURL;

// 判断附件是否已经上传到服务器，通过附件是否存在objectID判断
@property (nonatomic, assign, readonly) BOOL isUploaded;

// 判断附件是否可以删除，用于区分占为附件
@property (nonatomic, assign, readonly) BOOL removeEnabled;

// 拍照，调用相机/相册获取图片
@property (nonatomic, strong, readonly) RACCommand *takePhotoCommand;

// 删除, 本地/服务器json解析附件
@property (nonatomic, strong, readonly) RACCommand *removeCommand;

// 上传， 上传本地附件图片文件到服务器
@property (nonatomic, strong, readonly) RACCommand *uploadAttachmentCommand;

// 下载， 下载服务器附件图片文件
@property (nonatomic, strong, readonly) RACCommand *downloadAttachmentCommand;

// 判断是否可以调用获取图片命令
//
// 当附件是占为附件的时候,可以通过takePhotoCommand获取本地图片
// 当附件非占为附件的时候，不可以添加本地图片
- (RACSignal *)takePhotoValidSignal;

// 上传命令是否有效
//
// 当附件文件没有objectID的时候可以上传附件, 否则服务器已经存在无法上传
- (RACSignal *)uploadValidSignal;

// 下载命令是否有效
//
// 存在objectID, 且以附件`name`文件在本地不存在, 则可以执行下载附件
- (RACSignal *)downloadValidSignal;

// 创建新的viewModel
//
// attachment - viewModel控制的附件对象
// services - 调用相机，以及上传用到的服务
//
// return 新的附件ViewModel
- (instancetype)initWthAttachment:(MSFAttachment *)attachment services:(id <MSFViewModelServices>)services;

@end
