//
//  MSFTrial.h
//  Finance
//
//  Created by 赵勇 on 12/25/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFTrial : MSFObject

@property (nonatomic, copy, readonly) NSString *loanFixedAmt;
@property (nonatomic, copy, readonly) NSString *lifeInsuranceAmt;

@end
