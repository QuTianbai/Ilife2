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

@interface MSFClient(MSFCart)

- (RACSignal *)fetchCart:(NSString *)appNo;
- (RACSignal *)fetchTrialAmount:(MSFCartViewModel *)viewModel;

@end
