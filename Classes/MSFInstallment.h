//
//	MSFStaging.h
//	Cash
//	期
//	Created by xutian on 15/5/14.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFInstallment : MSFObject

@property(nonatomic,copy,readonly) NSString *installmentID;
@property(nonatomic,copy,readonly) NSString *planID;
@property(nonatomic,copy,readonly) NSString *loanID;
@property(nonatomic,assign,readonly) double thePrincipal;//本金
@property(nonatomic,assign,readonly) double interest;//利息
@property(nonatomic,assign,readonly) double serviceCharge;
@property(nonatomic,assign,readonly) double totalMoney;

@end
