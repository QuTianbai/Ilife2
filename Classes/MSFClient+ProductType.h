//
//  MSFClient+MSFProductType.h
//  Finance
//
//  Created by 赵勇 on 11/21/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (ProductType)

// 获取产品群类型ID, 返回一个信号发送产品群ID数组
- (RACSignal *)fetchProductType;

@end
