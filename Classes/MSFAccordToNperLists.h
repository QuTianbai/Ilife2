//
//	MSFAccordToNperList.h
//	Cash
//	根据金额获取期数列表
//	Created by xutian on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFAccordToNperLists : MSFObject

@property(nonatomic,copy,readonly) NSString *installmentID;
@property(nonatomic,assign,readonly) int nper;

@end
