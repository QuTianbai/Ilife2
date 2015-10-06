//
// MSFElement.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFElement : MSFObject

// type `IDCARD`
@property (nonatomic, copy, readonly) NSString *type;

@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, copy, readonly) NSString *name;

@property (nonatomic, copy, readonly) NSString *comment;

// 示例图片地址
@property (nonatomic, copy, readonly) NSURL *sampleURL;

// 图标地址
@property (nonatomic, copy, readonly) NSURL *thumbURL;

// 是否必须
@property (nonatomic, assign, readonly) BOOL required;

// 最大上传数量
@property (nonatomic, assign, readonly) NSUInteger maximum;

@end
