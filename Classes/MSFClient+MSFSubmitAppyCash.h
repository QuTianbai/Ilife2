//
//  MSFClient+MSFSubmitAppyCash.h
//  Finance
//
//  Created by xbm on 15/10/3.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@class MSFApplyCashModel;

@interface MSFClient (MSFSubmitAppyCash)

- (RACSignal *)fetchSubmitWithApplyVO:(MSFApplyCashModel *)infoModel AndAcessory:(id)AccessoryInfoVO Andstatus:(NSString *)status;

@end
