//
//  MSFMyRepayTableViewCell.m
//  Finance
//
//  Created by xbm on 16/2/26.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayTableViewCell.h"
#import "MSFMyRepayViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFMyRepayTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contractTitle;
@property (weak, nonatomic) IBOutlet UILabel *repayTime;
@property (weak, nonatomic) IBOutlet UILabel *repayMoney;
@property (nonatomic, strong) MSFMyRepayViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *repayedLB;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;

@end

@implementation MSFMyRepayTableViewCell

- (void)awakeFromNib {
	RAC(self, contractTitle.text) = RACObserve(self, viewModel.contractTitle);
	RAC(self, repayTime.text) = RACObserve(self, viewModel.repayTime);
	RAC(self, repayMoney.text) = RACObserve(self, viewModel.repayMoney);
	[[RACObserve(self, viewModel.status) ignore:nil]
	 subscribeNext:^(NSString *x) {
		 if ([x isEqualToString:@"已还款"]) {
			 self.repayedLB.transform = CGAffineTransformMakeRotation(M_PI_4);
			 self.repayedLB.hidden = NO;
			 self.imgBg.hidden = NO;
		 } else {
			 self.repayedLB.hidden = YES;
			 self.imgBg.hidden = YES;
		 }
	 }];
}

- (void)bindViewModel:(id)viewModel {
	if ([viewModel isKindOfClass:MSFMyRepayViewModel.class]) {
		self.viewModel = viewModel;
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
