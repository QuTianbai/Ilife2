//
// MSFEntity.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@class MSFServer;

/**
 *  用户实体,虚类，用以扩展用户关联信息
 */
@interface MSFEntity : MSFObject

/**
 *  用户手机号
 */
@property(nonatomic,copy,readonly) NSString *phone;

/**
 *  用户名，对应用户真实名字
 */
@property(nonatomic,copy,readonly) NSString *name;

/**
 *  身份证号
 */
@property(nonatomic,copy,readonly) NSString *idcard;

/**
 *  用户银行卡号
 */
@property(nonatomic,copy,readonly) NSString *passcard;

/**
 *  头像URL
 */
@property(nonatomic,copy,readonly) NSURL *avatarURL;

@end
