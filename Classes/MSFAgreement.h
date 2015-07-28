//
// MSFAgreement.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@class MSFServer;
@class MSFProduct;

@interface MSFAgreement : MSFObject

/**
 *	用户协议地址
 */
@property (nonatomic, strong, readonly) NSURL *userURL;

/**
 *	贷款协议地址
 */
@property (nonatomic, strong, readonly) NSURL *loanURL;

/**
 *	关于我们地址
 */
@property (nonatomic, strong, readonly) NSURL *aboutWeURL;

/**
 *	产品介绍地址
 */
@property (nonatomic, strong, readonly) NSURL *productURL;

/**
 *	帮助中心地址
 */
@property (nonatomic, strong, readonly) NSURL *helpURL;

/**
 *	网点分布地址
 */
@property (nonatomic, strong, readonly) NSURL *branchesURL;

/**
 *	网点分布地址
 */
@property (nonatomic, strong, readonly) NSURL *repayURL;
@property (nonatomic, strong, readonly) NSURL *registerURL;

@property (nonatomic, strong, readonly) NSURL *lifeInsuranceURL;

- (instancetype)initWithServer:(MSFServer *)server;

@end