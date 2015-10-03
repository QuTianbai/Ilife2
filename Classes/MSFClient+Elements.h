//
// MSFClient+Elements.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFProduct;

@interface MSFClient (Elements)

- (RACSignal *)fetchElementsWithProduct:(MSFProduct *)product __deprecated_msg("Use fetchElementsWithProduct:product:amount:term");
- (RACSignal *)fetchElementsWithProduct:(MSFProduct *)product amount:(NSString *)amount term:(NSString *)term;

@end
