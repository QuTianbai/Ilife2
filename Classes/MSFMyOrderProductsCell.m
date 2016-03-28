//
//  MSFMyOrderProductsCell.m
//  Finance
//
//  Created by xbm on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderProductsCell.h"
#import "MSFMyOrderCmdViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCommodity.h"

@interface MSFMyOrderProductsCell ()

@property (weak, nonatomic) IBOutlet UILabel *productNameLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *productDescribLB;
@property (weak, nonatomic) IBOutlet UILabel *productNumsLB;
@property (nonatomic, strong) MSFMyOrderCmdViewModel *viewModel;
@property (nonatomic, strong) MSFCommodity *model;

@end

@implementation MSFMyOrderProductsCell

- (void)awakeFromNib {
	RAC(self, productNameLB.text) = [RACObserve(self, viewModel.cmdtyName) map:^id(id value) {
		return value;
	}];
	RAC(self, priceLB.text) = RACObserve(self, viewModel.cmdtyPrice);
	RAC(self, productDescribLB.text) = RACObserve(self, viewModel.brandName);
	RAC(self, productNumsLB.text) = RACObserve(self, viewModel.pcsCount);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
