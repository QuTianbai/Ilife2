//
// MSFUserViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class MSFUser;
@class RACCommand;
@class MSFAuthorizeViewModel;
@class MSFBankCardListViewModel;

@interface MSFUserViewModel : RVMViewModel

@property (nonatomic, strong, readonly) MSFUser *model;
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, copy, readonly) NSString *percent;
@property (nonatomic, assign, readonly) BOOL isAuthenticated;
@property (nonatomic, weak, readonly) MSFAuthorizeViewModel *authorizeViewModel;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@property (nonatomic, strong) NSString *usedPassword __deprecated;
@property (nonatomic, strong) NSString *updatePassword __deprecated;
@property (nonatomic, strong) NSString *username __deprecated;
@property (nonatomic, strong) NSString *mobile __deprecated;
@property (nonatomic, strong) NSString *identifyCard __deprecated;
@property (nonatomic, strong) RACCommand *executeUpdatePassword __deprecated;
@property (nonatomic, strong, readonly) MSFBankCardListViewModel *bankCardListViewModel __deprecated;
- (instancetype)initWithAuthorizeViewModel:(MSFAuthorizeViewModel *)viewModel services:(id <MSFViewModelServices>)services __deprecated;

@end
