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

@interface MSFMyOrderProductsCell ()

@property (weak, nonatomic) IBOutlet UILabel *productNameLB;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *productDescribLB;
@property (weak, nonatomic) IBOutlet UILabel *productNumsLB;
@property (nonatomic, strong) MSFMyOrderCmdViewModel *viewModel;

@end

@implementation MSFMyOrderProductsCell

- (void)awakeFromNib {
	RAC(self, productNameLB.text) = RACObserve(self, viewModel.cmdtyName);
	RAC(self, priceLB.text) = RACObserve(self, viewModel.cmdtyPrice);
	RAC(self, productDescribLB) = RACObserve(self, viewModel.brandName);
	RAC(self, productNumsLB) = RACObserve(self, viewModel.pcsCount);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

}

@end
