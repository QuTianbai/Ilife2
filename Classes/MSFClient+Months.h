//
// MSFClient+Months.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFMonths;

@interface MSFClient (Months)

- (RACSignal *)fetchTermPayWithProduct:(MSFMonths *)product totalAmount:(NSInteger)amount insurance:(BOOL)insurance;

@end
