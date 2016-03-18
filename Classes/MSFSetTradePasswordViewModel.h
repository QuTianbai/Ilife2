//
//  MSFSetTradePasswordViewModel.h
//  Finance
//
//  Created by xbm on 15/10/3.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import <UIKit/UIKit.h>

@class RACCommand;

@interface MSFSetTradePasswordViewModel : RVMViewModel

@property (nonatomic, assign) BOOL counting;

@property (nonatomic, copy) NSString *TradePassword;
@property (nonatomic, copy) NSString *smsCode;

@property (nonatomic, strong) UIImage *captchaNomalImage;
@property (nonatomic, strong) UIImage *captchaHighlightedImage;

// Signup/Signin send captcha code tip label, default `获取验证码`
@property (nonatomic, strong) NSString *counter;

// six bit captcha code
@property (nonatomic, strong) NSString *captcha;


@property (nonatomic, strong) RACCommand *executeCaptcha;

- (RACSignal *)captchaRequestValidSignal;

- (instancetype)initWithServices:(id<MSFViewModelServices>)services;

@end
