//
//  MSFClient+ConfirmContract.h
//  Finance
//
//  Created by xbm on 15/9/3.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (ConfirmContract)

// 用户主动提交合同单号给服务器确认合同
//
// appNO - 合同号
// productCode - 产品群代码
// templateType - 合同类型
//
// Returns a signal which sends a MSFConfirmContractModel or error
- (RACSignal *)fetchConfirmContractWithAppNO:(NSString *)appNO AndProductNO:(NSString *)productCode AndtemplateType:(NSString *)templateType;

@end
