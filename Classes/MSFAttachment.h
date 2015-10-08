//
// MSFAttachment.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFAttachment : MSFObject

// 获取的需要上传的清单附件信息本息

// 文件id
@property (nonatomic, copy, readonly) NSString *fileID;

// 文件名
@property (nonatomic, copy, readonly) NSString *fileName;

// 文件类型名
@property (nonatomic, copy, readonly) NSString *name;

// 文件类型 eg. IDCARD
@property (nonatomic, copy, readonly) NSString *type;

// 文件描述 eg `身份证`
@property (nonatomic, copy, readonly) NSString *plain;

// 获取下载的已经上传的文件详细信息

// 申请单id
@property (nonatomic, copy, readonly) NSString *applyID;

// 申请号
@property (nonatomic, copy, readonly) NSString *applyNo;

// 评论详细URL
@property (nonatomic, copy, readonly) NSURL *commentURL;

// 附件添加时间
@property (nonatomic, strong, readonly) NSDate *additionDate;

// 附件更新时间
@property (nonatomic, strong, readonly) NSDate *updatedDate;

// 文档状态，I--初始，Y--合格，N--不合格
@property (nonatomic, copy, readonly) NSString *status;

// 附件上传，后从服务器返回的json中的文件类型 `image/jpg`
@property (nonatomic, copy, readonly) NSString * contentType __deprecated_msg("Unused 2.0");
@property (nonatomic, copy, readonly) NSString * contentName __deprecated_msg("Unused 2.0");
@property (nonatomic, copy, readonly) NSString * contentID __deprecated_msg("Unused 2.0");

// 文件缩略图地址
//
// - 如果文件是本地牌照图片，则文件缩略图地址是本地图片存储地址
// - 如果文件是尚未拍照，或者下载，则缩略图地址占位图地址
@property (nonatomic, strong) NSURL *thumbURL;

// 拍照图片存储地址
@property (nonatomic, strong) NSURL *fileURL;

// 判断当前附件viewModel是否是占位用于弹出拍照控件的cell
@property (nonatomic, assign, readonly) BOOL isPlaceholder;

@end
