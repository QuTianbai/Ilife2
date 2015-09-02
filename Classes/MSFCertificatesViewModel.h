//
//  MSFCertificatesViewModel.h
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@interface MSFCertificatesViewModel : RVMViewModel

@property (nonatomic, strong) NSArray *viewModels;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (instancetype)initWithService:(id<MSFViewModelServices>)service;

@end
