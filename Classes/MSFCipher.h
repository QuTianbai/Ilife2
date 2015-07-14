//
// Cipher.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSFSignature;

@interface MSFCipher : NSObject

// 服务器返回的时间戳
@property (nonatomic, assign, readonly) long long sessionId;

// 请求服务器后对应的本地接收的时间戳
@property (nonatomic, assign, readonly) long long serialization;

// 加密密钥
@property (nonatomic, copy, readonly) NSString *signKey;

- (instancetype)initWithSession:(long long)contestant;

- (MSFSignature *)signatureWithPath:(NSString *)path parameters:(NSDictionary *)parameters;

// 每次请求的时候获取的时间戳
- (long long)bumpstamp;

@end
