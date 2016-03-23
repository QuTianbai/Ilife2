//
// MSFClient+Cipher.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Cipher)

// 获取服务器时间戳，用于加密
- (RACSignal *)fetchServerInterval;

@end
