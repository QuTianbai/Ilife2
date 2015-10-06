//
//  MSFBankCardListModel.h
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFBankCardListModel : MSFObject

@property (nonatomic, copy, readonly) NSString *bankCardId;
@property (nonatomic, copy, readonly) NSString *bankCardNo;
@property (nonatomic, copy, readonly) NSString *bankCardType;
@property (nonatomic, copy, readonly) NSString *bankCode;
@property (nonatomic, copy, readonly) NSString *bankName;
@property (nonatomic, copy, readonly) NSString *bankBranchCityCode;
@property (nonatomic, copy, readonly) NSString *bankBranchProvinceCode;
//@property (nonatomic, assign, readonly) BOOL isMaster;
@property (nonatomic, assign, readonly) BOOL master;

@end
