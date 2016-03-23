//
// MSFClient+Advers.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Advers)

- (RACSignal *)fetchAdverWithCategory:(NSString *)category;

@end
