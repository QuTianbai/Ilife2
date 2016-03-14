//
//  MSFCustomAlertViewController.h
//  alert
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 xbm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFConfirmContractViewModel;

@interface MSFCustomAlertViewController : UIViewController

@property (nonatomic, strong) MSFConfirmContractViewModel *viewModel;

- (void)bindBTRACCommand;

@end
