//
// MSFAuthorizeResponse.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

typedef enum : NSUInteger {
	MSFClientTypeNomal,
	MSFClientTypeWhiteList,
} MSFClientType;

@interface MSFAuthorizeResponse : MSFObject

@property (nonatomic, copy, readonly) NSString *uniqueId;
@property (nonatomic, assign, readonly) MSFClientType clientType;

@end
