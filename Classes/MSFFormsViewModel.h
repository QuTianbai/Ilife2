//
// MSFFormsViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

/**
 *	Application Form ViewModel
 */

@class MSFMarket;
@class MSFApplicationForms;

@interface MSFFormsViewModel : RVMViewModel

@property (nonatomic, strong, readonly) MSFApplicationForms *model;
@property (nonatomic, strong, readonly) MSFMarket *market;
@property (nonatomic, strong, readonly) RACSignal *updatedContentSignal;

@property (nonatomic, assign, readonly) BOOL pending;
@property (nonatomic, assign) BOOL isHaveProduct;//是否请求到贷款信息和贷款期数

- (RACSignal *)submitSignalWithPage:(NSInteger)page;
- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
