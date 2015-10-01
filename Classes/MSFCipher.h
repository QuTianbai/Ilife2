//
// Cipher.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const MSFCipherAppKey;
extern NSString *const MSFCipherAppSecret;

@class MSFSignature;

// 请求加密
//
// 通过服务器请求返回的字段对请求参数生成加密签名`MSFSignature`
@interface MSFCipher : NSObject

// 服务器返回的时间戳
@property (nonatomic, assign, readonly) long long internet;

// 请求服务器后对应的本地接收的时间戳, 创建对象的时候自动生成时间戳
@property (nonatomic, assign, readonly) long long client;

// Create MSFCipher instance
//
// contestant - 通过MSFClient+Cipher `-fetchServerInterval`,获取的服务器时间戳
//
// Return cipher Use to create signature
- (instancetype)initWithTimestamp:(long long)contestant;

// Create MSFSignature instance
//
// path				- HTTP Request Path
// parameters - HTTP Request Parameters
//
// Return signature contain sign and timestamp
- (MSFSignature *)signatureWithPath:(NSString *)path parameters:(NSDictionary *)parameters;

// 每次请求的时候获取的时间戳
- (long long)bumpstamp;

@end
