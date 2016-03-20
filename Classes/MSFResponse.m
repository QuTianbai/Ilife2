//
// MSFResponse.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFResponse.h"
#import <Mantle/EXTKeyPathCoding.h>

@interface MSFResponse ()

@property (nonatomic, strong) NSHTTPURLResponse *HTTPURLResponse;

@end

@implementation MSFResponse

- (instancetype)initWithHTTPURLResponse:(NSHTTPURLResponse *)response parsedResult:(id)parsedResult {
	return [super initWithDictionary:@{
		@keypath(self.HTTPURLResponse): response.copy ?: NSNull.null,
		@keypath(self.parsedResult): parsedResult ?: NSNull.null,
	} error:nil];
}

- (NSUInteger)statusCode {
	return self.HTTPURLResponse.statusCode;
}

@end
