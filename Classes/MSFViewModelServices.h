//
// MSFViewModelServices.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSFClient;
@class RACSignal;

@protocol MSFViewModelServices <NSObject>

// Pop viewModel from navigtion controller stack
- (void)popViewModel;

// Push viewmodel into navigation controller stack
- (void)pushViewModel:(id)viewModel;

// Present viewmodel into current view
- (void)presentViewModel:(id)viewModel;

// Client global instance.
- (MSFClient *)httpClient;

// Update When signIn or SignUp.
//
// client - authenticated client or unauthenticated client.
- (void)setHttpClient:(MSFClient *)client;

// 调用相机拍照/模拟器的情况下直接获取相册图片
- (RACSignal *)msf_takePictureSignal;
//人脸识别前置图片
- (void)ImagePickerControllerWithImage:(id )iamge;

- (RACSignal *)msf_barcodeScanSignal;

@end
