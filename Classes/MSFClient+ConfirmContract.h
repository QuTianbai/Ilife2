//
//  MSFClient+ConfirmContract.h
//  Finance
//
//  Created by xbm on 15/9/3.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (ConfirmContract)

- (RACSignal *)fetchConfirmContractWithAppNO:(NSString *)appNO AndProductNO:(NSString *)productCode AndtemplateType:(NSString *)templateType;

@end
