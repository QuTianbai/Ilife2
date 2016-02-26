//
//  MSFMyRepayTableViewCell.m
//  Finance
//
//  Created by xbm on 16/2/26.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayTableViewCell.h"
#import "MSFRepaymentSchedulesViewModel.h"

@interface MSFMyRepayTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contractTitle;
@property (weak, nonatomic) IBOutlet UILabel *repayTime;
@property (weak, nonatomic) IBOutlet UILabel *repayMoney;
@property (nonatomic, strong) MSFRepaymentSchedulesViewModel *viewModel;

@end

@implementation MSFMyRepayTableViewCell

- (void)awakeFromNib {
	
}

- (void)bindViewModel:(id)viewModel {
	if ([viewModel isKindOfClass:MSFRepaymentSchedulesViewModel.class]) {
		self.viewModel = viewModel;
		self.contractTitle.text = self.viewModel.contractTitle ?: @"";
		self.repayTime.text = self.viewModel.repayTime ?: @"";
		self.repayMoney.text = self.viewModel.repayMoney ?: @"";
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
