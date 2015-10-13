//
// MSFViewModelServices.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSFClient;
@class RACSignal;

@protocol MSFViewModelServices <NSObject>

- (void)popViewModel;

- (void)pushViewModel:(id)viewModel;
- (void)presentViewModel:(id)viewModel;

// Client instance.
- (MSFClient *)httpClient;

// Update When signIn or SignUp.
//
// client - authenticated client or unauthenticated client.
- (void)setHttpClient:(MSFClient *)client;

- (RACSignal *)msf_takePictureSignal;

@end
