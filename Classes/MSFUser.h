//
// MSFUser.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@class MSFServer;
@class MSFPersonal;
@class MSFProfessional;
@class MSFSocialInsurance;
@class MSFSocialProfile;
@class MSFContact;

@interface MSFUser : MSFObject

// 用户姓名
@property (nonatomic, copy, readonly) NSString *name;

// 用户手机号
@property (nonatomic, copy, readonly) NSString *mobile;

// 判断用户是否已设置交易密码
@property (nonatomic, assign, readonly) BOOL hasTransactionalCode;

//客户分类
@property (nonatomic, copy, readonly) NSString *custType;

//是否经过实名认证
@property (nonatomic, copy, readonly) NSString *hasChecked;

@property (nonatomic, copy, readwrite) NSString *uniqueId;
@property (nonatomic, copy, readwrite) NSString *applyType;

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

// 用户信息
@property (nonatomic, strong, readonly) NSString *maritalStatus;
@property (nonatomic, strong, readonly) MSFPersonal *personal;
@property (nonatomic, strong, readonly) MSFProfessional *professional;
@property (nonatomic, strong, readonly) MSFSocialInsurance *insurance;
@property (nonatomic, strong, readonly) NSArray *profiles;
@property (nonatomic, strong, readonly) NSArray *contacts;

@end
