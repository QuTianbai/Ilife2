//
//  MSFClient+MSFCart.h
//  Finance
//
//  Created by 赵勇 on 12/25/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@class RACSignal;
@class MSFCartViewModel;

@interface MSFClient(Cart)

- (RACSignal *)fetchCart:(NSString *)appNo;
- (RACSignal *)fetchTrialAmount:(MSFCartViewModel *)viewModel;
- (RACSignal *)submitTrialAmount:(MSFCartViewModel *)viewModel;

@end
