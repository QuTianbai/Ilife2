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
#import "UIColor+Utils.h"

@interface MSFMyRepayTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contractTitle;
@property (weak, nonatomic) IBOutlet UILabel *repayTime;
@property (weak, nonatomic) IBOutlet UILabel *repayMoney;
@property (nonatomic, strong) MSFMyRepayViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *repayedLB;
@property (weak, nonatomic) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UILabel *repayTimeTitleLB;

@end

@implementation MSFMyRepayTableViewCell

- (void)awakeFromNib {
	RAC(self, contractTitle.text) = RACObserve(self, viewModel.contractTitle);
	RAC(self, repayTime.text) = RACObserve(self, viewModel.repayTime);
	RAC(self, repayMoney.attributedText) = RACObserve(self, viewModel.repayMoney);
	[[RACObserve(self, viewModel.status) ignore:nil]
	 subscribeNext:^(NSString *x) {
		 if ([x isEqualToString:@"已还款" ]
             ) {
             self.repayedLB.text = x;
             self.repayedLB.textColor = [UIColor whiteColor];
			 self.repayedLB.transform = CGAffineTransformMakeRotation(M_PI_4);
			 self.repayedLB.hidden = NO;
			 self.imgBg.hidden = NO;
			 self.contractTitle.textColor = [UIColor lightGrayColor];
			 self.repayTime.textColor = [UIColor lightGrayColor];
			 self.repayTimeTitleLB.textColor = [UIColor lightGrayColor];
			 self.imgBg.alpha = 0.7;
         } else if ([x isEqualToString:@"已逾期" ] || [x isEqualToString:@"还款中"]) {
             self.repayedLB.text = x;
             self.repayedLB.textColor = [UIColor blackColor];
             if ([x isEqualToString:@"已逾期"]) {
                self.repayedLB.textColor = [UIColor percentColor];
             }
            self.repayedLB.transform = CGAffineTransformMakeRotation(M_PI_4);
             self.repayedLB.hidden = NO;
             self.imgBg.hidden = NO;
             self.contractTitle.textColor = [UIColor blackColor];
             self.repayTime.textColor = [UIColor blackColor];
             self.repayTimeTitleLB.textColor = [UIColor blackColor];
             self.imgBg.alpha = 0.7;
         }else {
			 self.repayedLB.hidden = YES;
			 self.imgBg.hidden = YES;
			 self.contractTitle.textColor = [UIColor blackColor];
			 self.repayTime.textColor = [UIColor blackColor];
			 self.repayTimeTitleLB.textColor = [UIColor blackColor];
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
