//
//  MSFUserContact.m
//  Finance
//
//  Created by 赵勇 on 9/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFUserContact.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFUserContact ()

@property (nonatomic, assign, readwrite) BOOL isFamily;

@end

@implementation MSFUserContact

- (instancetype)init {
	self = [super init];
	if (self) {
		@weakify(self)
		[RACObserve(self, contactRelation) subscribeNext:^(id x) {
			@strongify(self)
			self.isFamily = [@[@"RF01", @"RF02", @"RF03", @"RF06", @"RF04", @"RF05"] containsObject:x];
		}];
	}
	return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{};
}

@end
