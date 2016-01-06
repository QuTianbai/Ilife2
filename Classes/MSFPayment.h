//
// MSFPayment.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFPayment : MSFObject

@property (nonatomic, copy, readonly) NSString *authType;
@property (nonatomic, copy, readonly) NSString *authId;
@property (nonatomic, copy, readonly) NSString *authCode;
@property (nonatomic, copy, readonly) NSString *expireDate;
@property (nonatomic, copy, readonly) NSString *downPmt;

@end
