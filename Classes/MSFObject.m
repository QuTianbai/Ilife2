//
// MSFObject.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"
#import "MSFServer.h"

@interface MSFObject ()

@property (nonatomic, strong, readwrite) MSFServer *server;

@end

@implementation MSFObject

#pragma mark - Lifecycle

- (instancetype)init {
	self = [super init];
	if (self == nil) {
		return nil;
	}
	self.server = MSFServer.dotComServer;
	
	return self;
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{};
}

+ (NSValueTransformer *)objectIDJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

- (BOOL)validateObjectID:(id *)objectID error:(NSError **)error {
	id object  = *objectID;
	if ([object isKindOfClass:NSString.class]) {
		return YES;
	} else if ([object isKindOfClass:NSNumber.class]) {
		*objectID = [*objectID stringValue];
		return YES;
	}
	
	return *objectID == nil;
}

#pragma mark Properties

- (NSURL *)baseURL {
	return self.server.baseURL;
}

- (void)setBaseURL:(NSURL *)baseURL {
	if ([self.baseURL isEqual:baseURL]) {
		return;
	}
	
	if (baseURL == nil) {
		self.server = MSFServer.dotComServer;
	} else {
		NSString *baseURLString = [NSString stringWithFormat:@"%@://%@", baseURL.scheme, baseURL.host];
		self.server = [MSFServer serverWithBaseURL:[NSURL URLWithString:baseURLString]];
	}
}

#pragma mark - NSObject

- (NSUInteger)hash {
	return self.server.hash ^ self.objectID.hash ^ [super hash];
}

- (BOOL)isEqual:(MSFObject *)obj {
	if (self == obj) return YES;
	if (![obj isMemberOfClass:self.class]) return NO;
	
	return [obj.server isEqual:self.server] && [obj.objectID isEqual:self.objectID];
}

@end
