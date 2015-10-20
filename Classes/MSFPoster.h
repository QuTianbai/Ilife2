//
// MSFPoster.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

// 启动获取的广告宣传图片对象
@interface MSFPoster : MSFObject

// 图片地址
@property (nonatomic, copy, readonly) NSURL *photoURL;

// 图片有效开始时间
@property (nonatomic, strong, readonly) NSDate *startDate;

// 图片失效时间
@property (nonatomic, strong, readonly) NSDate *endDate;

@end
