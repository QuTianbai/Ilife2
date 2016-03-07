//
//  MSFMyRepayListWalletDetailTableViewCell.m
//  Finance
//
//  Created by xbm on 16/3/2.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayListWalletDetailTableViewCell.h"
#import "MSFWithDrawViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFMyRepayListWalletDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *dayL;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIImageView *bankImg;
@property (weak, nonatomic) IBOutlet UILabel *contractTitle;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNo;
@property (weak, nonatomic) IBOutlet UILabel *nomeyLB;
@property (strong, nonatomic) MSFWithDrawViewModel *viewModel;

@end

@implementation MSFMyRepayListWalletDetailTableViewCell

- (void)awakeFromNib {
	
	RAC(self, dayL.text) = RACObserve(self, viewModel.withdrawDate);
	RAC(self, bankName.text) = RACObserve(self, viewModel.bankName);
	RAC(self, nomeyLB.text) = RACObserve(self, viewModel.withdrawMoney);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)bindViewModel:(id)viewModel {
	if ([viewModel isKindOfClass:MSFWithDrawViewModel.class]) {
		self.viewModel = viewModel;
	}
}

@end
