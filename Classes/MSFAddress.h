//
// MSFAddress.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

// 地址
//
// 申请贷款列表中, 在`个人地址` `工作单位地址`, 当服务器已经存在地址内容，客户端需要根据
// 服务器返回的地址编码, 转换地址对象,
//
// MSFAddressViewModel
// `- initWithAddress:services:` 传入address对象创建ViewModel,
// 并在ViewModel中完成网络地址到本地显示地址的转换
@interface MSFAddress : MSFObject

// The province code
@property (nonatomic, copy, readonly) NSString *province;

// The city code
@property (nonatomic, copy, readonly) NSString *city;

// The country code
@property (nonatomic, copy, readonly) NSString *area;

@end
