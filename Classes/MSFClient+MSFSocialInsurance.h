//
//  MSFClient+MSFSocialInsurance.h
//  Finance
//
//  Created by xbm on 15/11/23.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@class MSFSocialInsuranceModel;

@interface MSFClient (MSFSocialInsurance)

- (RACSignal *)fetchSubmitSocialInsuranceInfoWithModel:(MSFSocialInsuranceModel *)model;

@end
