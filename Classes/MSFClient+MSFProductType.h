//
//  MSFClient+MSFProductType.h
//  Finance
//
//  Created by 赵勇 on 11/21/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFProductType)

- (RACSignal *)fetchProductType;

@end
