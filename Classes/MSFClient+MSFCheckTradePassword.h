//
//  MSFClient+MSFCheckTradePassword.h
//  Finance
//
//  Created by xbm on 15/9/30.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFCheckTradePassword)

- (RACSignal *)fetchCheckTradePassword;

@end
