//
// MSFClient+LoanTypes.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (LoanTypes)

// Fetch valid <MSFLoanType>
//
// Returns a signal will send <MSFLoanType> instance
- (RACSignal *)fetchLoanTypes;

@end
