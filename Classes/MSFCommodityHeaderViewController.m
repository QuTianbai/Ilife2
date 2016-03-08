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
	RAC(self, nextBT.titleLabel.text) = RACObserve(self, viewModel.buttonTitle);
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
	
	self.barCoderBT.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [[self.viewModel.services msf_barcodeScanSignal] doNext:^(id x) {
			MSFCartViewController *vc = [[MSFCartViewController alloc] initWithApplicationNo:x services:self.viewModel.services];
			[self.navigationController pushViewController:vc animated:YES];
		}];
	}];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
    
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
