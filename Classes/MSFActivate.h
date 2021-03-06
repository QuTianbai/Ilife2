//
// MSFUtils.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class MSFPoster;

@interface MSFActivate : NSObject

// 设置数据请求，启动程序需要服务器最新的时间戳，然后再载入界面
//
// Returns an signal after fetch server timestamp
+ (RACSignal *)setupSignal;

// 存储用户登录手机号, 在登录/注册成功后更新
+ (void)setSignInMobile:(NSString *)phone;

// 获取存储的用户登录手机号
+ (NSString *)signInMobile;

// 获取一个有效的广告宣传图对象
+ (MSFPoster *)poster;

@end

