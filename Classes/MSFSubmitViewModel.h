//
//  MSFSubmitViewModel.h
//  Cash
//
//  Created by xbm on 15/6/9.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFAFViewModel.h"

@class MSFSelectKeyValues;
@class RACCommand;
@class MSFPhotoStatus;

@interface MSFSubmitViewModel : MSFAFViewModel
/**
 *银行名称
 */
@property(nonatomic,strong) MSFSelectKeyValues *bankName;
/**
 *银行卡号
 */
@property(nonatomic,copy) NSString *bankCardNum;
/*
 *白名单照片
 */
@property(nonatomic,strong) MSFPhotoStatus *phtoStatus;

@property(nonatomic,strong) RACCommand *executeRequest;

@property(nonatomic,strong) RACSignal *buttonEnable;
- (RACSignal *)requestValidSignal;

@end
