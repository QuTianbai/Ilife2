//
//	MSFAdver.h
//	Cash
//
//	Created by xbm on 15/5/14.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//ios测试驱动开发

#import "MSFObject.h"

@interface MSFAdver : MSFObject

@property(nonatomic,copy,readonly) NSString *adID;
@property(nonatomic,copy,readonly) NSString *title;
@property(nonatomic,assign,readonly) NSInteger type;
@property(nonatomic,copy,readonly) NSString *adDescription;
@property(nonatomic,copy,readonly) NSURL *adURL;
@property(nonatomic,copy,readonly) NSURL *imgURL;
@property(nonatomic,copy,readonly) NSString *imageName;

@end
