//
//  MSFClient+MSFOrder.h
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@class RACSignal;
@class MSFOrderDetail;

@interface MSFClient(MSFOrder)

- (RACSignal *)fetchOrderList:(NSString *)status pageNo:(NSInteger)pn;
- (RACSignal *)fetchOrder:(NSString *)orderId;
- (RACSignal *)fetchTrialAmount:(MSFOrderDetail *)order;

@end
