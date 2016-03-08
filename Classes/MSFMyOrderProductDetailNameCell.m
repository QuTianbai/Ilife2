//
//  MSFMyOrderProductDetailNameCell.m
//  Finance
//
//  Created by xbm on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderProductDetailNameCell.h"
#import "MSFMyOrderListProductsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFMyOrderProductDetailNameCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *mobleLB;
@property (nonatomic, strong) MSFMyOrderListProductsViewModel *viewModel;

@end

@implementation MSFMyOrderProductDetailNameCell

- (void)awakeFromNib {
	RAC(self, nameLB.text) = RACObserve(self, viewModel.custName);
	RAC(self, mobleLB.text) = RACObserve(self, viewModel.cellphone);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
