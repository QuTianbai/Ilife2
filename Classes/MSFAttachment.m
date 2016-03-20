//
// MSFAttachment.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAttachment.h"
#import <Mantle/EXTKeyPathCoding.h>

@interface MSFAttachment ()

@property (nonatomic, assign, readwrite) BOOL isPlaceholder;
@property (nonatomic, assign, readwrite) BOOL isUpload;

@end

@implementation MSFAttachment

#pragma mark - Lifecycle

- (instancetype)initWithFileURL:(NSURL *)URL applicationNo:(NSString *)applicaitonNo elementType:(NSString *)type elementName:(NSString *)name {
	NSParameterAssert(applicaitonNo);
	return [self initWithDictionary:@{
		@keypath(MSFAttachment.new, fileURL): URL,
		@keypath(MSFAttachment.new, thumbURL): URL,
		@keypath(MSFAttachment.new, applicationNo): applicaitonNo,
		@keypath(MSFAttachment.new, type): type,
		@keypath(MSFAttachment.new, name): name,
		@keypath(MSFAttachment.new, isPlaceholder): @NO,
	} error:nil];
}

- (instancetype)initWithAssetsURL:(NSURL *)URL applicationNo:(NSString *)applicaitonNo elementType:(NSString *)type elementName:(NSString *)name {
	NSParameterAssert(applicaitonNo);
	return [self initWithDictionary:@{
		@keypath(MSFAttachment.new, thumbURL): URL,
		@keypath(MSFAttachment.new, applicationNo): applicaitonNo,
		@keypath(MSFAttachment.new, type): type,
		@keypath(MSFAttachment.new, name): name,
		@keypath(MSFAttachment.new, isPlaceholder): @YES,
	} error:nil];
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"objectID": @"fileId",
		@"fileID": @"fileId",
		@"fileName": @"fileName",
	};
}

+ (NSSet *)propertyKeys {
	NSMutableSet *keys = [super.propertyKeys mutableCopy];

	// This is a derived property.
	[keys removeObject:@keypath(MSFAttachment.new, isPlaceholder)];
	[keys removeObject:@keypath(MSFAttachment.new, isUpload)];

	return keys;
}

#pragma mark - NSObject

- (BOOL)isEqual:(MSFAttachment *)other {
	if (other == self) {
		return YES;
	} else if (![super isEqual:other]) {
		return NO;
	} else {
		return [other.objectID isEqualToString:self.objectID];
	}
}

- (NSUInteger)hash {
	return self.objectID.hash ^ self.thumbURL.hash;
}

#pragma mark - Public

- (void)mergeAttachment:(MSFAttachment *)attachment {
	self.isUpload = YES;
	[self mergeValueForKey:@keypath(MSFAttachment.new, objectID) fromModel:attachment];
	[self mergeValueForKey:@keypath(MSFAttachment.new, fileID) fromModel:attachment];
	[self mergeValueForKey:@keypath(MSFAttachment.new, fileName) fromModel:attachment];
}

@end
