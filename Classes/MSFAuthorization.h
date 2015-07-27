//
// MSFAuthorization.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFAuthorization : MSFObject

// finance
@property (nonatomic, copy, readonly) NSString *token;

// msfinance
@property (nonatomic, copy, readonly) NSString *session;

@end
