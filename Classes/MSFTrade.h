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
@property (nonatomic, copy, readonly) NSDate *tradeDate;
@property (nonatomic, assign, readonly) NSString *tradeAmount;
@property (nonatomic, copy, readonly) NSString *tradeDescription;

@end
