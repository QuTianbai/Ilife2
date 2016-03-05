//
//  MSFMyOrderProdutBottomCell.m
//  Finance
//
//  Created by xbm on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderProdutBottomCell.h"
#import "MSFMyOrderListProductsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFMyOrderProdutBottomCell ()

@property (weak, nonatomic) IBOutlet UILabel *pay;
@property (weak, nonatomic) IBOutlet UILabel *months;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *isJionInsurance;
@property (nonatomic, strong) MSFMyOrderListProductsViewModel *viewModel;

@end

@implementation MSFMyOrderProdutBottomCell

- (void)awakeFromNib {
	RAC(self, pay.text) = RACObserve(self, viewModel.downPmt);
	RAC(self, months.text) = RACObserve(self, viewModel.mthlyPmtAmt);
	RAC(self, money.text) = RACObserve(self, viewModel.loanAmt);
	RAC(self, isJionInsurance.hidden) = [RACObserve(self, viewModel.valueAddedSvc) map:^id(NSString *value) {
		return @([value isEqualToString:@"0"]);
	}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}


@end
