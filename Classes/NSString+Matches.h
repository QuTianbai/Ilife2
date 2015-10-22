//
// NSString+Matches.h
//
// Copyright (c) 2014年 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Matches)

/**
 *	电话判断:手机/座机
 *
 *	@return true/false
 */
- (BOOL)isTelephone;

/**
 *	手机号判断
 */
- (BOOL)isMobile;

/**
 *	数字判断
 */
- (BOOL)isScalar;

/**
 *	邮箱判断
 */
- (BOOL)isMail;

/**
 *	身份证判断
 */
- (BOOL)isIdentityCard;

/**
 *	密码有效性判定
 */
- (BOOL)isPassword;

/**
 *	验证码有效性判定
 */
- (BOOL)isCaptcha;

/**
 *	中文名有效性判定
 */
- (BOOL)isChineseName;

/**
 *	验证码有效性判定
 */
- (BOOL)isFormValid;

/**
 *	数字有效性判定
 */
- (BOOL)isNum;

- (BOOL)isValidName;

- (BOOL)isValidIDCardRange:(NSRange)range;

/**
 * 交易密码是否相各位相同
 */
- (BOOL)isSimplePWD;

/**
 *	判定是不是固定电话短区号
 */
- (BOOL)isShortAreaCode;

@end
