//
//  MSFContactListModel.h
//  Finance
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFContactListModel : MSFObject

@property (nonatomic, copy, readonly) NSString *contactID;
@property (nonatomic, copy, readonly) NSString *contractNo;
@property (nonatomic, copy, readonly) NSString *contLoanApplyId;
@property (nonatomic, copy, readonly) NSString *contLoanApplyNo;
@property (nonatomic, copy, readonly) NSString *contractStatus;

@end
