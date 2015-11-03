//
// MSFClozeViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFClient;
@class MSFAddressViewModel;
@class MSFBankInfoModel;
@class MSFAuthorizeViewModel;

@interface MSFClozeViewModel : RVMViewModel

// The User realname, Identifier Card name
@property (nonatomic, strong) NSString *name;

// identfier Card no
@property (nonatomic, strong) NSString *card;

// The identifer Card invalid time
@property (nonatomic, strong) NSDate *expired;

// The bank name
@property (nonatomic, strong) NSString *bankName;

// BankInfo
@property (nonatomic, strong) MSFBankInfoModel *bankInfo;

//BankSize
@property (nonatomic, copy) NSString *maxSize;

// Bank code
@property (nonatomic, strong) NSString *bankCode;

// The bank no
@property (nonatomic, strong) NSString *bankNO;

//The bank type
@property (nonatomic, copy) NSString *bankType;

//	The bank Address String value compose with `province city 
@property (nonatomic, strong) NSString *bankAddress;

// Execute Request Command
@property (nonatomic, strong, readonly) RACCommand *executeAuth;

// Execute Select Address Command
@property (nonatomic, strong, readonly) RACCommand *executeSelected;

// User Identifier card is or not life time valid
@property (nonatomic, assign) BOOL permanent;

// Identifier Card lifelong valid command
@property (nonatomic, strong, readonly) RACCommand *executePermanent;

// Address Select ViewModel
@property (nonatomic, strong, readonly) MSFAddressViewModel *addressViewModel;
@property (nonatomic, weak, readonly) MSFAuthorizeViewModel *authorizeViewModel;

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services __deprecated;
- (instancetype)initWithServices:(id <MSFViewModelServices>)services authorizeViewModel:(MSFAuthorizeViewModel *)viewModel;

@end
