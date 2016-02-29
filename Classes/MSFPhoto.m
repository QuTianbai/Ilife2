//
//	MSFPhoto.m
//	Cash
//
//	Created by xbm on 15/6/3.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFPhoto.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MSFPhoto

#pragma mark - Lifecycle

- (instancetype)initWithURL:(NSURL *)URL {
	return [super initWithDictionary:@{@keypath(self.URL): URL} error:nil];
}

- (instancetype)initWithURLString:(NSString *)URL {
	return [self initWithURL:[NSURL URLWithString:URL]];
}

@end
