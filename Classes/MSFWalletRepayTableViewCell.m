//
//  MSFWalletRepayTableViewCell.m
//  Finance
//
//  Created by Wyc on 16/3/17.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFWalletRepayTableViewCell.h"
#import "MSFRepayPlanViewModle.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFWalletRepayTableViewCell ()

@property (nonatomic, strong) MSFRepayPlanViewModle *viewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;

@end

@implementation MSFWalletRepayTableViewCell

- (void)awakeFromNib {
	RAC(self, dateLB.text) = RACObserve(self, viewModel.loanExpireDate);
	RAC(self, statusLB.text) = RACObserve(self, viewModel.status);
	RAC(self, moneyLB.text) = RACObserve(self, viewModel.repaymentTotalAmount);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
