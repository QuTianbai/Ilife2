//
//  MSFApplyListViewModel.h
//  Finance
//
//  Created by 赵勇 on 11/24/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MSFViewModelServices.h"

@class RACSignal;

@interface MSFApplyListViewModel : MTLModel

@property (nonatomic, strong, readonly) NSString *productType;

- (RACSignal *)fetchApplyListSignal;
- (instancetype)initWithProductType:(NSString *)productType services:(id<MSFViewModelServices>)services;

@end
