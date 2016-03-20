//
// MSFClient+Amortize.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Amortize)

- (RACSignal *)fetchAmortizeWithProductCode:(NSString *)productCode;

@end
