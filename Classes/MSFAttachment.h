//
// MSFAttachment.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFAttachment : MSFObject

// 文件id
@property (nonatomic, copy, readonly) NSString *fileID;

// 文件名
@property (nonatomic, copy, readonly) NSString *fileName;

// 文件类型名
@property (nonatomic, copy, readonly) NSString *name;

// 文件类型 eg. IDCARD
@property (nonatomic, copy, readonly) NSString *type;

// 文件缩略图地址
//
// - 如果文件是本地牌照图片，则文件缩略图地址是本地图片存储地址
// - 如果文件是尚未拍照，或者下载，则缩略图地址占位图地址
@property (nonatomic, strong) NSURL *thumbURL;

// 拍照图片存储地址
@property (nonatomic, strong) NSURL *fileURL;

// 是否上传
@property (nonatomic, assign, readonly) BOOL isUpload;

// 申请订单号
@property (nonatomic, copy, readonly) NSString *applicationNo;

// 判断当前附件viewModel是否是占位用于弹出拍照控件的cell
@property (nonatomic, assign, readonly) BOOL isPlaceholder;


// Create attachment instance
//
// URL - 图怕存储的路径URL
// applicationNo - 当前附件清单的申请订单编号
// elementType - 附件所属的元素类型
// elementName - 附件所属的元素名称, 例: 身份证
//
// Returns 创建具备图片路径的对象
- (instancetype)initWithFileURL:(NSURL *)URL applicationNo:(NSString *)applicaitonNo elementType:(NSString *)type elementName:(NSString *)name;

// 创建默认占位图片对象
- (instancetype)initWithAssetsURL:(NSURL *)URL applicationNo:(NSString *)applicaitonNo elementType:(NSString *)type elementName:(NSString *)name;

// 提交后合并服务器返回的文件ID，文件名
- (void)mergeAttachment:(MSFAttachment *)attachment;

@end

@interface MSFAttachment (Deprecated)

@property (nonatomic, copy, readonly) NSString *plain __deprecated;
@property (nonatomic, copy, readonly) NSString *applyID __deprecated;
@property (nonatomic, copy, readonly) NSString *applyNo __deprecated;
@property (nonatomic, copy, readonly) NSURL *commentURL __deprecated;
@property (nonatomic, strong, readonly) NSDate *additionDate __deprecated;
@property (nonatomic, strong, readonly) NSDate *updatedDate __deprecated;
@property (nonatomic, copy, readonly) NSString *status __deprecated;

// Create blank attachment
// Uset to take photo
//
// URL -  file url for default image
+ (instancetype)blankAttachmentWithAssetsURL:(NSURL *)URL __deprecated;


// Create instance with photo URL
//
// URL					 -  The disk file URL
// applicaitonNo - applicaiton number
// type					 - The attachment type
//
// Returns the instance
- (instancetype)initWithFileURL:(NSURL *)URL applicationNo:(NSString *)applicaitonNo elementType:(NSString *)type __deprecated;

@end
