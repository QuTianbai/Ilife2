//
// MSFUserViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFAuthorizeViewModel;
@class MSFBankCardListViewModel;

@interface MSFUserViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> servcies;

@property (nonatomic, strong) NSString *usedPassword;
@property (nonatomic, strong) NSString *updatePassword;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *identifyCard;

@property (nonatomic, strong) RACCommand *executeUpdatePassword;

@property (nonatomic, strong, readonly) MSFAuthorizeViewModel *authorizeViewModel;
@property (nonatomic, strong, readonly) MSFBankCardListViewModel *bankCardListViewModel;

- (instancetype)initWithAuthorizeViewModel:(MSFAuthorizeViewModel *)viewModel services:(id <MSFViewModelServices>)services;

@end
