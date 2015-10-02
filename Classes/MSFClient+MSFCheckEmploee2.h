//
//  MSFClient+MSFCheckEmploee2.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFCheckEmploee2)

- (RACSignal *)fetchCheckEmploeeWithProductCode:(NSString *)code;

@end
