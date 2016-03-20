//
//  MSFTrial.h
//  Finance
//
//  Created by 赵勇 on 12/25/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFTrial : MSFObject

@property (nonatomic, copy) NSString *loanFixedAmt;
@property (nonatomic, copy) NSString *lifeInsuranceAmt;
@property (nonatomic, copy) NSString *loanTerm;

// 商品贷特有属性
@property (nonatomic, copy) NSString *promId;

@end
