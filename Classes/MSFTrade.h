//
//	MSFTrade.h
//	Cash
//	交易
//	Created by xutian on 15/5/14.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFTrade : MSFObject

@property (nonatomic, copy, readonly) NSString *tradeID;
@property (nonatomic, copy, readonly) NSString *tradeDate;
@property (nonatomic, assign, readonly) double	 tradeAmount;
@property (nonatomic, copy, readonly) NSString *tradeDescription;

@end
