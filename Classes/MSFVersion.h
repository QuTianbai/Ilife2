//
// MSFVersion.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

/**
 *	版本信息
 */
@interface MSFVersion : MSFObject

/**
 *	10001, 内部版本号,对应iOS的编译版本号
 */
@property (nonatomic, copy, readonly) NSString *code;

/**
 *	1.0.0", 外部版本号，对应iOS用户显示版本号
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *	渠道
 */
@property (nonatomic, copy, readonly) NSString *channel;

/**
 *	版本icon
 */
@property (nonatomic, copy, readonly) NSURL *iconURL;

/**
 *	更新地址
 */
@property (nonatomic, copy, readonly) NSURL *updateURL;

/**
 *	更新描述
 */
@property (nonatomic, copy, readonly) NSString *summary;

/**
 *	更新时间
 */
@property (nonatomic, copy, readonly) NSString *date;

@end
