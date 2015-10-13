//
// MSFUtils.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface MSFUtils : NSObject

// 设置数据请求，启动程序需要服务器最新的时间戳，然后再载入界面
//
// Returns an signal after fetch server timestamp
+ (RACSignal *)setupSignal;

// 存储用户登录手机号
+ (void)setSignInMobile:(NSString *)phone;
+ (NSString *)signInMobile;

@end

