//
//	MSFAccordToNperList.h
//	Cash
//
//	Created by xutian on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

//	根据金额获取期数列表
@interface MSFAccordToNperLists : MSFObject

@property (nonatomic, copy, readonly) NSString *installmentID;
@property (nonatomic, assign, readonly) int nper;

@end
