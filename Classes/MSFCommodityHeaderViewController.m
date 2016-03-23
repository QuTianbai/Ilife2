//
//  MSFCommodityHeaderViewController.m
//  Finance
//
//  Created by xbm on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCommodityHeaderViewController.h"
#import "MSFCommodityViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCartViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFCommodityHeaderViewController ()

@property (weak, nonatomic) IBOutlet UIView *saosaoBT;
@property (nonatomic, weak) MSFCommodityViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *lastOrderLB;
@property (weak, nonatomic) IBOutlet UILabel *contractStatusLB;
@property (weak, nonatomic) IBOutlet UIButton *nextBT;
@property (weak, nonatomic) IBOutlet UIImageView *nextImg;
@property (weak, nonatomic) IBOutlet UIButton *barCoderBT;

@end

@implementation MSFCommodityHeaderViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	RAC(self.lastOrderLB, text) = RACObserve(self, viewModel.hasList);
	RAC(self.contractStatusLB, text) = RACObserve(self, viewModel.statusString);
	[RACObserve(self, viewModel.buttonTitle) subscribeNext:^(id x) {
		[self.nextBT setTitle:x forState:UIControlStateNormal];
	}];
	RAC(self.nextBT, rac_command) = RACObserve(self, viewModel.excuteActionCommand);
	@weakify(self)
	RAC(self, nextBT.hidden) = [RACObserve(self, viewModel.buttonTitle) map:^id(NSString *value) {
		@strongify(self)
		if (value.length == 0) {
			self.nextImg.hidden = YES;
			return @YES;
		}
		self.nextImg.hidden = NO;
		return @NO;
	}];
	
	self.barCoderBT.rac_command = self.viewModel.executeCartCommand;
	
	[self.viewModel.executeCartCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
    
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
