//
// MSFUser.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@class MSFServer;

@interface MSFUser : MSFObject

/**
 *	用户手机号
 */
@property (nonatomic, copy, readonly) NSString *phone;

/**
 *	用户名，对应用户真实名字
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *	身份证号
 */
@property (nonatomic, copy, readonly) NSString *idcard;

/**
 *	用户银行卡号
 */
@property (nonatomic, copy, readonly) NSString *passcard;

/**
 *	头像URL
 */
@property (nonatomic, copy, readonly) NSURL *avatarURL;

/**
 *	创建用户
 *
 *	@param name	 用户名，可以为 ""
 *	@param phone 用户手机号，必须
 *
 *	@return user
 */
+ (instancetype)userWithName:(NSString *)name phone:(NSString *)phone __deprecated_msg("`Use -userWithServer:`");

/**
 *	Create The user instance
 *
 *	@param server server
 *
 *	@return The user instance
 */
+ (instancetype)userWithServer:(MSFServer *)server;

/**
 *	判断User是否通过实名认证
 *
 *	@return 已经通过实名，认证则返回YES
 */
- (BOOL)isAuthenticated;

@end
