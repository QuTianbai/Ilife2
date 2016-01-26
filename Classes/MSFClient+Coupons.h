//
// MSFClient+Coupons.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Coupons)

- (RACSignal *)fetchCouponsWithStatus:(NSString *)status;
- (RACSignal *)addCouponWithCode:(NSString *)code;

@end
