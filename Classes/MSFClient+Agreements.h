//
// MSFClient+Agreements.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFProduct;
@class MSFApplyCashVIewModel;

@interface MSFClient (Agreements)

- (RACSignal *)fetchAgreementURLWithProduct:(MSFApplyCashVIewModel *)product;

@end
