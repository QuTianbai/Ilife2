//
// MSFClientAdditions.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

// Convenience category to retreive parsedResults from OCTResponses.
@interface RACSignal (MSFClientAdditions)

// This method assumes that the receiver is a signal of OCTResponses.
//
// Returns a signal that maps the receiver to become a signal of
// OCTResponse.parsedResult.
- (RACSignal *)msf_parsedResults;

@end
