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

// Create Tab‘s Controller.
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

// Global application forms information.
@property (nonatomic, strong, readonly) MSFFormsViewModel *formsViewModel;

// Global authorize ViewModel.
@property (nonatomic, strong, readonly) MSFAuthorizeViewModel *authorizeViewModel;

// 授权信息变化信号.
//
// SignIn,
// SignUp,
// SignOut,
// Update SignIn Password,
// Update Mobile Number.
@property (nonatomic, strong, readonly) RACSignal *authorizationUpdatedSignal;


// Create ViewModel
//
// services -  Created by Appdelegate.
//
// Returns viewModel instance.
- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
