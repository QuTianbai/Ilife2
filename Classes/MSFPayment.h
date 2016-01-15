//
// MSFPayment.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFPayment : MSFObject

// 普通支付返回相关信息
@property (nonatomic, copy, readonly) NSString *authType;
@property (nonatomic, copy, readonly) NSString *authId;
@property (nonatomic, copy, readonly) NSString *authCode;
@property (nonatomic, copy, readonly) NSString *expireDate;
@property (nonatomic, copy, readonly) NSString *downPmt;

// 首付返回相关信息
@property (nonatomic, copy, readonly) NSString *bankCode;
@property (nonatomic, copy, readonly) NSString *bankName;
@property (nonatomic, copy, readonly) NSString *bankCardType;
@property (nonatomic, copy, readonly) NSString *bankCardNo;

@end
