//
//  MSFContactListModel.h
//  Finance
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

__attribute__((deprecated("This class is deprecated. Please use the MSFApplylist class instead")))

//TODO: Rename contact to contract
@interface MSFContactListModel : MSFObject

@property (nonatomic, copy, readonly) NSString *contactID;
@property (nonatomic, copy, readonly) NSString *contractNo;
@property (nonatomic, copy, readonly) NSString *contLoanApplyId;
@property (nonatomic, copy, readonly) NSString *contLoanApplyNo;
@property (nonatomic, copy, readonly) NSString *contractStatus;

@end
