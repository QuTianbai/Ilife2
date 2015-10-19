//
// MSFResponse.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MTLModel.h"

@interface MSFResponse : MTLModel

// Server response statusCode.
@property (nonatomic, assign, readonly) NSUInteger statusCode;

// Server response dictionary or model object.
@property (nonatomic, strong, readonly) id parsedResult;

// Create MSFResponse instance.
//
// response - The NSHTTPURLResponse instance.
// parsedResult -  The server response object dictionary nil or object.
//
// Returns MSFResponse instance.
- (instancetype)initWithHTTPURLResponse:(NSHTTPURLResponse *)response parsedResult:(id)parsedResult;

@end
