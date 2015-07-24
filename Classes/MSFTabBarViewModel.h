//
// MSFTabBarViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFFormsViewModel;
@class MSFAuthorizeViewModel;

@interface MSFTabBarViewModel : RVMViewModel

@property (nonatomic, strong, readonly) MSFClient *client __deprecated;
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

// 登录控制
@property (nonatomic, strong, readonly) RACCommand *signInCommand;
@property (nonatomic, strong, readonly) RACCommand *signUpCommand;
@property (nonatomic, strong, readonly) RACCommand *verifyCommand;

@property (nonatomic, strong, readonly) MSFFormsViewModel *formsViewModel;

@property (nonatomic, strong, readonly) MSFAuthorizeViewModel *authorizeViewModel;
@property (nonatomic, strong, readonly) RACSignal *authorizationUpdatedSignal;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
