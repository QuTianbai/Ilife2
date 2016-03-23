//
//  MSFMyOrderListTravalDetailCell.m
//  Finance
//
//  Created by xbm on 16/3/8.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderListTravalDetailCell.h"
#import "MSFMyOrderListProductsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFMyOrderCmdViewModel.h"

@interface MSFMyOrderListTravalDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *goTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UILabel *backTimeLB;
@property (nonatomic, strong) MSFMyOrderListProductsViewModel *viewModel;
@property (nonatomic, strong) MSFMyOrderCmdViewModel *cmdViewModel;

@end

@implementation MSFMyOrderListTravalDetailCell

- (void)awakeFromNib {
	RAC(self, titleLB.text) = [RACObserve(self, cmdViewModel.cmdtyName) ignore:nil];
	RAC(self, goTimeLB.text) = RACObserve(self, viewModel.orderTravelDto.departureTime);
	RAC(self, moneyLB.text) = RACObserve(self, viewModel.totalAmt);
	RAC(self, backTimeLB.text) = RACObserve(self, viewModel.orderTravelDto.returnTime);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(id)viewModel atIndexPath:(NSIndexPath *)indexPath {
	self.viewModel = viewModel;
    self.cmdViewModel = self.viewModel.cmdtyList[indexPath.row];
}

@end
