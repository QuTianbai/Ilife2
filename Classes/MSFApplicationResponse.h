//
//	MSFApplyCash.h
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

__attribute__((deprecated("This class is unavailable.")))

@interface MSFApplicationResponse : MSFObject

@property (nonatomic, copy, readonly) NSString *applyID;
@property (nonatomic, copy, readonly) NSString *personId;
@property (nonatomic, copy, readonly) NSString *applyNo;

@end
