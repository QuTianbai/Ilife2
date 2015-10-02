//
//  MSFClient+MSFBankCardList.h
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFBankCardList)

- (RACSignal *)fetchBankCardList;

@end
