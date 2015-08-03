//
// MSFClientAdditions.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

// Convenience category to retreive parsedResults from MSFResponses.
@interface RACSignal (MSFClientAdditions)

// This method assumes that the receiver is a signal of MSFResponses.
//
// Returns a signal that maps the receiver to become a signal of
// MSFResponse.parsedResult.
- (RACSignal *)msf_parsedResults;

@end
