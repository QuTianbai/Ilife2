//
// MSFInsuranceViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@interface MSFInsuranceViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, readonly) NSString *applicaitonNo;
@property (nonatomic, readonly) NSString *productId;

@end
