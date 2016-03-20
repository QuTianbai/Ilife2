//
//  MSFApplyCashModel.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

// 马上贷申请资料
@interface MSFApplyCashModel : MSFObject

@property (nonatomic, copy) NSString *appNo;
@property (nonatomic, copy) NSString *appLmt;
@property (nonatomic, assign) int applyStatus;
@property (nonatomic, copy) NSString *loanTerm;
@property (nonatomic, copy) NSString *loanPurpose;
@property (nonatomic, copy) NSString *jionLifeInsurance;
@property (nonatomic, copy) NSString *lifeInsuranceAmt;
@property (nonatomic, copy) NSString *loanFixedAmt;
@property (nonatomic, copy) NSString *productCd;

@end
