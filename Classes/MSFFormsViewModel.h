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
@class MSFMarkets;
@class MSFApplicationForms;
@class MSFAddress;

@interface MSFFormsViewModel : RVMViewModel

@property (nonatomic, assign) BOOL master;
@property (nonatomic, copy) NSString *masterBankCardNO;

@property (nonatomic, copy) NSString *masterbankInfo;

@property (nonatomic, strong, readonly) NSArray *bankCardArray;
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) MSFApplicationForms *model;
@property (nonatomic, strong, readonly) MSFMarket *market __deprecated;
@property (nonatomic, strong, readonly) MSFMarkets *markets;
@property (nonatomic, strong, readonly) RACSignal *updatedContentSignal;
@property (nonatomic, strong, readonly) MSFAddress *currentAddress;
@property (nonatomic, strong, readonly) MSFAddress *workAddress;

@property (nonatomic, assign, readonly) BOOL pending;
@property (nonatomic, assign) BOOL isHaveProduct;//是否请求到贷款信息和贷款期数

- (RACSignal *)submitUserInfoType:(int)infoType;//2.0上传用户信息
- (instancetype)initWithServices:(id <MSFViewModelServices>)services;
- (void)setBankCardMasterDefult;

@end
