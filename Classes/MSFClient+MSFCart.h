//
//  MSFClient+MSFCart.h
//  Finance
//
//  Created by 赵勇 on 12/25/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@class RACSignal;
@class MSFCart;

@interface MSFClient(MSFCart)

- (RACSignal *)fetchCart:(NSString *)cartId;
- (RACSignal *)fetchTrialAmount:(MSFCart *)cart;

@end
