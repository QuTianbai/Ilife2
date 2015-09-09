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
@property (weak, nonatomic) IBOutlet UILabel *messageLB;

@end

@implementation MSFCustomAlertViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
}

- (void)viewWillAppear:(BOOL)animated {
	self.messageLB.numberOfLines = 0;
}

- (void)bindBTRACCommand {
	self.laterConfirmBT.rac_command = self.viewModel.laterConfirmCommand;
	self.nowConfirmBT.rac_command = self.viewModel.confirmCommand;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
