//
// MSFPlanViewModel.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class MSFTrial;

@interface MSFPlanViewModel : RVMViewModel

@property (nonatomic, strong, readonly) MSFTrial *model;
@property (nonatomic, strong, readonly) NSString *text;

- (instancetype)initWithModel:(id)model;
- (instancetype)initWithModel:(id)model services:(id <MSFViewModelServices>)services __deprecated;
- (instancetype)initWithModel:(id)model viewModel:(id)viewModel services:(id <MSFViewModelServices>)services __deprecated;

@end
