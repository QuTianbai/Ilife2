//
// MSFClient+Payment.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFOrderDetail;
@class MSFPayment;

@interface MSFClient (Payment)

- (RACSignal *)paymentWithOrder:(MSFOrderDetail *)order password:(NSString *)password;
- (RACSignal *)fetchDownPayment:(MSFOrderDetail *)order password:(NSString *)password authType:(NSString *)auth;
- (RACSignal *)downPaymentWithPayment:(MSFOrderDetail *)order SMSCode:(NSString *)smsCode SMSSeqNo:(NSString *)seqNo;
- (RACSignal *)requestLoan:(MSFOrderDetail *)order;

@end
