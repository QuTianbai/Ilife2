//
// MSFTabBarViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFClient;
@class RACCommand;
@class MSFFormsViewModel;
@class MSFAuthorizeViewModel;

@interface MSFTabBarViewModel : RVMViewModel

// HTTP Request client
//
// MSFUtils httpClient
@property (nonatomic, strong, readonly) MSFClient *client;

// 登录控制
@property (nonatomic, strong, readonly) RACCommand *signInCommand;
@property (nonatomic, strong, readonly) RACCommand *verifyCommand;

@property (nonatomic, strong, readonly) MSFFormsViewModel *formsViewModel;

@property (nonatomic, strong, readonly) MSFAuthorizeViewModel *authorizeViewModel;
@property (nonatomic, strong, readonly) RACSignal *authorizationUpdatedSignal;

- (RACSignal *)signInSignal;
- (RACSignal *)verifySignal;

@end
