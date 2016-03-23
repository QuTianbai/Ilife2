//
// NSString+Matches.h
//
// Copyright (c) 2014年 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Matches)

// 电话判断:手机/座机
//
// Return true/false
- (BOOL)isTelephone;

// 手机号判断
- (BOOL)isMobile;

// 数字判断
- (BOOL)isScalar;

// 邮箱判断
- (BOOL)isMail;

//判断是否是金钱
- (BOOL)isMoney;
// 身份证判断
- (BOOL)isIdentityCard;

// 密码有效性判定
- (BOOL)isPassword;

// 验证码有效性判定
- (BOOL)isCaptcha;

// 中文名有效性判定
- (BOOL)isChineseName;

// 验证码有效性判定
- (BOOL)isFormValid;

// 数字有效性判定
- (BOOL)isNum;

// 中文姓名有效性判断
- (BOOL)isValidName;

// 身份证ID长度验证
- (BOOL)isValidIDCardRange:(NSRange)range;

// 交易密码是否相各位相同
- (BOOL)isSimplePWD;

// 判定是不是固定电话短区号
- (BOOL)isShortAreaCode;

@end
