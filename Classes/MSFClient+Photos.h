//
// MSFClient+Photos.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Photos)

// 获取广告位的图片
// type
// A 信用钱包
// B 商品贷
// C 马上贷
// D 申请成功
// E 提现成功
// F 闪屏
//
// Returns a singal which sends MSFPhoto with image URL or nil
- (RACSignal *)fetchAdv:(NSString *)type;

@end
