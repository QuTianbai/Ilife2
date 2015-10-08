//
// MSFClient+Elements.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFProduct;

@interface MSFClient (Elements)

- (RACSignal *)fetchElementsWithProduct:(MSFProduct *)product __deprecated_msg("Use fetchElementsWithProduct:product:amount:term");

// Fetch application need upload elements list.
//
// product - 贷款申请的产品信息，在2.0版本上这个产品信息使用`MSFUser`中的属性，则里传nil即可
// amount  - 贷款申请的总额
// term    - 贷款申请的期数
//
// Returns elements signal sequence
- (RACSignal *)fetchElementsWithProduct:(MSFProduct *)product amount:(NSString *)amount term:(NSString *)term;

@end
