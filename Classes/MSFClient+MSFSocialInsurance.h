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

- (RACSignal *)fetchSaveSocialInsuranceInfoWithModel:(MSFSocialInsuranceModel *)model;

- (RACSignal *)fetchSubmitSocialInsuranceInfoWithModel:(NSDictionary *)dict AndAcessory:(NSArray *)AccessoryInfoVO Andstatus:(NSString *)status;

- (RACSignal *)fetchGetSocialInsuranceInfo;
- (RACSignal *)confirmInsuranceSignal;

@end
