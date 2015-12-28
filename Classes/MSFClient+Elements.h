//
// MSFClient+Elements.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFProduct;

@interface MSFClient (Elements)

// 获取社保贷资料清单
//
// applicaitonNo - 申请订单号
// productID - 申请的产品
//
// Returns a signal will send element instance flow
- (RACSignal *)fetchElementsApplicationNo:(NSString *)applicaitonNo productID:(NSString *)productID;

// 获取资料重传清单
//
// applicaitonNo - 申请订单号
// productID     - 申请的产品
//
// Returns a signal will send element instance flow
- (RACSignal *)fetchSupplementalElementsApplicationNo:(NSString *)applicaitonNo productID:(NSString *)productID;

// 获取马上贷资料清单
//
// applicaitonNo - 申请订单号
// amount        - 申请金额
// terms         - 申请期数
//
// Returns a signal will send element instance flow
- (RACSignal *)fetchElementsApplicationNo:(NSString *)applicaitonNo amount:(NSString *)amount terms:(NSString *)terms productGroupID:(NSString *)groupID;

- (RACSignal *)fetchFaceMaskElements;

@end
