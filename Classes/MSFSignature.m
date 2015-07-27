//
// MSFSignature.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSignature.h"

@implementation MSFSignature

- (NSString *)query {
	return [NSString stringWithFormat:@"?sign=%@&timestamp=%@", self.sign, self.timestamp];
}

@end
