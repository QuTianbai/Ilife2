//
//	MSFReactiveView.h
//	Cash
//
//	Created by xbm on 15/5/31.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSFFormsViewModel;

@protocol MSFReactiveView <NSObject>

@optional

- (void)bindViewModel:(id)viewModel;

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel;

@end
