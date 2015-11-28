//
//  MSFLifeInsuranceViewModel.h
//  Finance
//
//  Created by xbm on 15/10/13.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@interface MSFLifeInsuranceViewModel : RVMViewModel

- (RACSignal *)lifeInsuranceHTMLSignal;


- (instancetype)initWithServices:(id<MSFViewModelServices>)services ProductID:(NSString *)productID;

@end
