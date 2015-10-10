//
// MSFUser.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@class MSFServer;

@interface MSFUser : MSFObject

// 用户是否已设置交易密码
@property (nonatomic, copy, readonly) NSString *hasTransPwd __deprecated_msg("Use `hasTransactionalCode`");

// 用户uniqueId
@property (nonatomic, copy, readonly) NSString *uniqueId;

@property (nonatomic, copy) NSString *complateCustInfo;

// 用户产品群
@property (nonatomic, copy, readonly) NSString *productId;

// 用户身份证号
@property (nonatomic, copy, readonly) NSString *ident;

// 用户userid
@property (nonatomic, copy, readonly) NSString *userID;

// 用户姓名
@property (nonatomic, copy, readonly) NSString *name;

// 用户手机号
@property (nonatomic, copy, readonly) NSString *mobile;

// 判断用户是否已设置交易密码
@property (nonatomic, assign, readonly) BOOL hasTransactionalCode;

// 客户类型
@property (nonatomic, copy, readonly) NSString *type;

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
