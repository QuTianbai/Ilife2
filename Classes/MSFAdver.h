//
//	MSFAdver.h
//	Cash
//
//	Created by xbm on 15/5/14.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.

#import "MSFObject.h"
#import "MSFAdverImage.h"

// 首页广告信息，暂没有测试数据，接口
@interface MSFAdver : MSFObject

@property (nonatomic, copy, readonly) NSString *ad_id;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *link_type;
@property (nonatomic, copy, readonly) NSString *desc;
@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, strong, readonly) MSFAdverImage *image;

@end
