//
// MSFUserViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class RACCommand;
@class MSFClient;
@class MSFAuthorizeViewModel;

@interface MSFUserViewModel : RVMViewModel

@property(nonatomic,strong,readonly) MSFClient *client;

@property(nonatomic,strong) NSString *usedPassword;
@property(nonatomic,strong) NSString *updatePassword;

@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *identifyCard;

@property(nonatomic,strong) RACCommand *executeUpdatePassword;

- (instancetype)initWithClient:(MSFClient *)client;

- (RACSignal *)updateValidSignal;

@property(nonatomic,strong,readonly) RACSignal *contentUpdateSignal;
@property (nonatomic, strong, readonly) MSFAuthorizeViewModel *authorizeViewModel;

- (instancetype)initWithAuthorizeViewModel:(MSFAuthorizeViewModel *)viewModel;

@end
