//
//	MSFAdver.h
//	Cash
//
//	Created by xbm on 15/5/14.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.

#import "MSFObject.h"

// 首页广告信息，暂没有测试数据，接口
@interface MSFAdver : MSFObject

@property (nonatomic, copy, readonly) NSString *adID;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, assign, readonly) NSInteger type;
@property (nonatomic, copy, readonly) NSString *adDescription;
@property (nonatomic, copy, readonly) NSURL *adURL;
@property (nonatomic, copy, readonly) NSURL *imgURL;
@property (nonatomic, copy, readonly) NSString *imageName;

@end
