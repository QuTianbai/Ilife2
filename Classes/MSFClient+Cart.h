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
@class MSFCart;

@interface MSFClient(Cart)

- (RACSignal *)fetchCart:(NSString *)appNo __deprecated_msg("Use -fetchCartInfoForCart:");
- (RACSignal *)fetchCartInfoForCart:(MSFCart *)cart;
- (RACSignal *)fetchTrialAmount:(MSFCartViewModel *)viewModel __deprecated;
- (RACSignal *)submitTrialAmount:(MSFCartViewModel *)viewModel __deprecated;

@end
