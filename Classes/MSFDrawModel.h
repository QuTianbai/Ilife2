//
//  MSFDrawModel.h
//  Finance
//
//  Created by xbm on 16/2/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFDrawModel : MSFObject

@property (nonatomic, copy, readonly) NSString *bankCode;
@property (nonatomic, copy, readonly) NSString *bankName;
@property (nonatomic, copy, readonly) NSString *bankCardNo;
@property (nonatomic, copy, readonly) NSString *withdrawDate;
@property (nonatomic, copy, readonly) NSString *withdrawMoney;

@end
