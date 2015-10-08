//
// MSFSignature.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSignature.h"

@implementation MSFSignature

- (NSString *)query {
	return [NSString stringWithFormat:@"?appKey=%@&sign=%@&timestamp=%@", self.appKey, self.sign, [self.timestamp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
