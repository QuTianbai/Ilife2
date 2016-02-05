//
//  MSFClient+MSFSocialInsurance.h
//  Finance
//
//  Created by xbm on 15/11/23.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@class MSFSocialInsuranceModel;

@interface MSFClient (SocialInsurance)

// 保存社保资料到服务器
//
// model - 社保贷 <MSFSocialInsuranceModel> instance
//
// Returns a signal will send a instance of <MSFApplicationResponse>
- (RACSignal *)fetchSaveSocialInsuranceInfoWithModel:(MSFSocialInsuranceModel *)model;

// 提交社保贷资料到服务器
//
// dic - 社保贷资料信息 <NSDictionary>
// AccessoryInfoVO - 社保贷附件信息 <NSDictionary>
// status - 社保贷保存还是最后一步提交社保申请 0 - 保存 1 - 提交 (无效字段)
// JoininLifeInsurance - 是否加入寿险计划
//
// Returns a signal which will send a MSFSubmitApplyModel
- (RACSignal *)fetchSubmitSocialInsuranceInfoWithModel:(NSDictionary *)dict AndAcessory:(NSArray *)AccessoryInfoVO Andstatus:(NSString *)status;

// 下载社保资料信息
//
// Returns a signal which will send a MSFSocialInsuranceModel
- (RACSignal *)fetchGetSocialInsuranceInfo;

- (RACSignal *)confirmInsuranceSignal __deprecated_msg("Replace this method with a empty signal");

@end
