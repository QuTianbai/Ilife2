//
// MSFResponse.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MTLModel.h"

@interface MSFResponse : MTLModel

@property (nonatomic, assign, readonly) NSUInteger statusCode;
@property (nonatomic, strong, readonly) id parsedResult;

- (instancetype)initWithHTTPURLResponse:(NSHTTPURLResponse *)response parsedResult:(id)parsedResult;

@end
