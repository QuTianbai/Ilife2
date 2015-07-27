//
//	MSFMonths.h
//	Cash
//
//	Created by xbm on 15/5/27.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"
#import "MSFSelectionItem.h"

@interface MSFProduct : MSFObject <MSFSelectionItem>

@property (nonatomic, copy, readonly) NSString *productId;
@property (nonatomic, copy, readonly) NSString *period;
@property (nonatomic, copy, readonly) NSString *proGroupId;
@property (nonatomic, copy, readonly) NSString *proGroupName;
@property (nonatomic, copy, readonly) NSString *monthlyFeeRate;
@property (nonatomic, copy, readonly) NSString *monthlyInterestRate;
@property (nonatomic, copy, readonly) NSString *productGroupCode;
@property (nonatomic, copy, readonly) NSString *productName;

@end
