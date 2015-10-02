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
@class MSFAddress;

@interface MSFFormsViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) MSFApplicationForms *model;
@property (nonatomic, strong, readonly) MSFMarket *market;
@property (nonatomic, strong, readonly) RACSignal *updatedContentSignal;
@property (nonatomic, strong, readonly) MSFAddress *currentAddress;
@property (nonatomic, strong, readonly) MSFAddress *workAddress;

@property (nonatomic, assign, readonly) BOOL pending;
@property (nonatomic, assign) BOOL isHaveProduct;//是否请求到贷款信息和贷款期数

- (RACSignal *)submitUserInfo;//2.0上传用户信息
- (RACSignal *)submitSignalWithPage:(NSInteger)page;
- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
