//
// MSFSignature.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Mantle/Mantle.h>

// 代码签名
@interface MSFSignature : MTLModel

// App key
@property (nonatomic, copy, readonly) NSString *appKey;

// 加密签名
@property (nonatomic, copy, readonly) NSString *sign;

// 加密时间戳
@property (nonatomic, copy, readonly) NSString *timestamp;

// 用对象的`sign` `timestamp` 拼接HTTP查询query
@property (nonatomic, readonly) NSString *query;

@end
