//
// MSFClient+Payment.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFOrderDetail;
@class MSFPayment;

@interface MSFClient (Payment)

// 获取支付的二维码订单号
//
// order - 订单信息
// password - 支付密码
//
// Returns a signal which sends MSFPayment or nil
- (RACSignal *)paymentWithOrder:(MSFOrderDetail *)order password:(NSString *)password;

// 获取首付信息
//
// order - 订单信息
// password - 支付密码
//
// Returns a signal which sends a MSFResponse or not
- (RACSignal *)fetchDownPayment:(MSFOrderDetail *)order password:(NSString *)password;

// 支付首付
//
// order - 订单信息
// SMSCode - 短信验证码
// segNo - 支付序列号
//
// Returns a signal which sends a MSFResponse or nil
- (RACSignal *)downPaymentWithPayment:(MSFOrderDetail *)order SMSCode:(NSString *)smsCode SMSSeqNo:(NSString *)seqNo;

- (RACSignal *)requestLoan:(MSFOrderDetail *)order __deprecated;

@end
