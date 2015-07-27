//
//	MSFRepayMent.h
//	Cash
//	还款
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFRepayMent : MSFObject

@property (nonatomic, copy, readonly) NSString *repaymentID;
@property (nonatomic, copy, readonly) NSString *expireDate;
@property (nonatomic, assign, readonly) double allAmount;

@end
