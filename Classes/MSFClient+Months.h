//
// MSFClient+Months.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFProduct;

@interface MSFClient (Months)

- (RACSignal *)fetchTermPayWithProduct:(MSFProduct *)product totalAmount:(NSInteger)amount insurance:(BOOL)insurance;

@end
