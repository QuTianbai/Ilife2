//
// MSFClient+Payment.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFOrderDetail;

@interface MSFClient (Payment)

- (RACSignal *)paymentWithOrder:(MSFOrderDetail *)order password:(NSString *)password;

@end
