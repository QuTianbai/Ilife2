//
//  MSFClient+MSFUserInfo.h
//  Finance
//
//  Created by 赵勇 on 9/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient(MSFUserInfo)

- (RACSignal *)fetchUserInfo;

@end
