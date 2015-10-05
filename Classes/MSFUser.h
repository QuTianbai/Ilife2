//
// MSFUser.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@class MSFServer;

@interface MSFUser : MSFObject

@property (nonatomic, copy, readonly) NSString *userID;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *mobile;

// 客户类型
//
// (0为马上贷客户，1为白名单客户）
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
