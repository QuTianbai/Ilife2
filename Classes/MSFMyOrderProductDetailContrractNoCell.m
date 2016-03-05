//
//  MSFMyOrderProductDetailContrractNoCell.m
//  Finance
//
//  Created by xbm on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderProductDetailContrractNoCell.h"
#import "MSFMyOrderListProductsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFMyOrderProductDetailContrractNoCell ()

@property (weak, nonatomic) IBOutlet UILabel *contractNoLB;
@property (weak, nonatomic) IBOutlet UILabel *contractStatusLB;
@property (nonatomic, strong) MSFMyOrderListProductsViewModel *viewModel;

@end

@implementation MSFMyOrderProductDetailContrractNoCell

- (void)awakeFromNib {
	RAC(self, contractNoLB.text) = RACObserve(self, viewModel.inOrderId);
	RAC(self, contractStatusLB.text) = RACObserve(self, viewModel.orderStatus);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
