//
// MSFReleaseNote.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@class MSFVersion;

/**
 *  程序版本信息
 */
@interface MSFReleaseNote : MSFObject

/**
 *  版本状态
 *  0：不需要升级，1:强制，2：非强制
 */
@property(nonatomic,assign,readonly) NSInteger status;

/**
 *  版本信息
 */
@property(nonatomic,strong,readonly) MSFVersion *version;

@end
