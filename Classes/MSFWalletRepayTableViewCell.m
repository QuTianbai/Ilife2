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
#import "UIColor+Utils.h"

@interface MSFWalletRepayTableViewCell ()

@property (nonatomic, strong) MSFRepayPlanViewModle *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;

@end

@implementation MSFWalletRepayTableViewCell

- (void)awakeFromNib {
	RAC(self, dateLB.text) = RACObserve(self, viewModel.loanExpireDate);
	RAC(self, statusLB.text) = RACObserve(self, viewModel.status);
	RAC(self, moneyLB.text) = RACObserve(self, viewModel.repaymentTotalAmount);
    [RACObserve(self, viewModel.contractStatus) subscribeNext:^(NSString *status) {
        if ([status isEqualToString:@"已还款"]) {
            self.statusLB.textColor = [UIColor lightGrayColor];
            self.dateLB.textColor = [UIColor lightGrayColor];
            self.moneyLB.textColor = [UIColor lightGrayColor];
        } else {
            self.statusLB.textColor = [UIColor percentColor];
            self.dateLB.textColor = [UIColor percentColor];
            self.moneyLB.textColor = [UIColor percentColor];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
