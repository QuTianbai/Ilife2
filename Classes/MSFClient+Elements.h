//
// MSFClient+Elements.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFProduct;

@interface MSFClient (Elements)

- (RACSignal *)fetchElementsWithProduct:(MSFProduct *)product;

@end
