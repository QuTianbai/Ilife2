//
//  MSFCustomAlertViewController.m
//  alert
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 xbm. All rights reserved.
//

#import "MSFCustomAlertViewController.h"
#import "MSFConfirmContactViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFCustomAlertViewController ()

@property (weak, nonatomic) IBOutlet UIButton *laterConfirmBT;
@property (weak, nonatomic) IBOutlet UIButton *nowConfirmBT;

@end

@implementation MSFCustomAlertViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
//	[[self.laterConfirmBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFCONFIRMCONTACTIONLATERNOTIFICATION" object:nil];
//	}];
	
}

- (void)bindBTRACCommand {
	self.laterConfirmBT.rac_command = self.viewModel.laterConfirmCommand;
	self.nowConfirmBT.rac_command = self.viewModel.confirmCommand;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
