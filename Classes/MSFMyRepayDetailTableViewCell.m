//
//  MSFMyRepayDetailTableViewCell.m
//  Finance
//
//  Created by xbm on 16/3/1.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayDetailTableViewCell.h"
#import "MSFCmdDetailViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFMyRepayDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contractTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *dateLB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (strong, nonatomic) MSFCmdDetailViewModel *viewModel;

@end

@implementation MSFMyRepayDetailTableViewCell

- (void)awakeFromNib {
	RAC(self, contractTitleLB.text) = RACObserve(self, viewModel.cmdtyName);
	RAC(self, dateLB.text) = RACObserve(self, viewModel.orderTime);
	RAC(self, moneyLB.text) = RACObserve(self, viewModel.cmdtyPrice);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(id)viewModel {
	if ([viewModel isKindOfClass:MSFCmdDetailViewModel.class]) {
		self.viewModel = viewModel;
	}
}


@end
