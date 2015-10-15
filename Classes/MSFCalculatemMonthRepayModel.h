//
//  MSFCalculatemMonthRepayModel.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFCalculatemMonthRepayModel : MSFObject

@property (nonatomic, copy, readonly) NSString *loanFixedAmt;

@property (nonatomic, copy, readonly) NSString *lifeInsuranceAmt;

@end
