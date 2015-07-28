//
// MSFClient+Agreements.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFProduct;

@interface MSFClient (Agreements)

- (RACSignal *)fetchAgreementURLWithProduct:(MSFProduct *)product;

@end
