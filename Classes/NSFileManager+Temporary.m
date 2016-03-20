//
// NSFileManager+Temporary.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "NSFileManager+Temporary.h"

@implementation NSFileManager (Temporary)

- (void)cleanupTemporaryFiles {
	NSArray *directory = [self contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
	for (NSString *file in directory) {
		[self removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
	}
}

@end
