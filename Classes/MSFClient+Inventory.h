//
// MSFClient+Inventory.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Inventory)

// 资料重传提交
//
// applicationNo - 申请订单号
// accessories   - 附件信息 NSArray/NDictionary
//
// Returns a signal will send instance of MSFResponse
- (RACSignal *)submitInventoryWithApplicaitonNo:(NSString *)applicationNo accessories:(id)accessories;

@end
