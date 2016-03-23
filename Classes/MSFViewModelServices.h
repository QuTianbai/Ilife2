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
- (RACSignal *)msf_takePictureSignal:(BOOL)frontOnly;

// 人脸识别前置图片
- (void)ImagePickerControllerWithImage:(id )iamge __deprecated;

// 扫描二维码
- (RACSignal *)msf_barcodeScanSignal;

// 获取交易密码
- (RACSignal *)msf_gainPasscodeSignal;

- (RACSignal *)msf_selectKeyValuesWithContent:(NSString *)content;
- (RACSignal *)msf_selectValuesWithContent:(NSString *)content keycode:(NSString *)keycode;

- (RACSignal *)msf_selectContactSignal;
//弹出设置交易密码
- (void)pushSetTransPassword;

@end
