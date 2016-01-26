//
// MSFCoupon.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFCoupon : MSFObject

@property (nonatomic, assign, readonly) NSInteger ticketRuleId;
@property (nonatomic, copy, readonly) NSString *ticketName;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *phone;
@property (nonatomic, copy, readonly) NSDate *receiveTime;
@property (nonatomic, copy, readonly) NSString *receiveChannel;
@property (nonatomic, strong, readonly) NSDate *effectDateBegin;
@property (nonatomic, strong, readonly) NSDate *effectDateEnd;
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, copy, readonly) NSString *value;

@end
