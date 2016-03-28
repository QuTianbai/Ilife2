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
#import "MSFCartViewModel.h"
#import "MSFCommodity.h"
#import "MSFCart.h"
#import "MSFTravel.h"

@interface MSFMyOrderListTravalDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *goTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UILabel *backTimeLB;
@property (nonatomic, strong) MSFMyOrderListProductsViewModel *viewModel;
@property (nonatomic, strong) MSFMyOrderCmdViewModel *cmdViewModel;
@property (nonatomic, assign) BOOL isOrderList;
@property (nonatomic, strong) MSFCommodity *commodityModel;
@property (nonatomic, strong) MSFCart *cartModel;

@property (nonatomic, weak) id myViewModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation MSFMyOrderListTravalDetailCell

- (void)awakeFromNib {
    @weakify(self)
    [RACObserve(self, myViewModel) subscribeNext:^(id viewModel) {
        @strongify(self)
        if ([viewModel isKindOfClass:[MSFCartViewModel class]]) {
            self.cartModel = (MSFCart *)((MSFCartViewModel *)viewModel).cart;
            self.commodityModel = ((MSFCart *)((MSFCartViewModel *)viewModel).cart).cmdtyList.firstObject?:[[MSFCart alloc] init];
            RAC(self, titleLB.text) = [[RACObserve(self, commodityModel.cmdtyName) ignore:nil] takeUntil:self.rac_prepareForReuseSignal];
            RAC(self, goTimeLB.text) = [[RACObserve(self, cartModel.travel.departureTime) map:^id(id value) {
                return [NSString stringWithFormat:@"出发时间%@", value];
            }] takeUntil:self.rac_prepareForReuseSignal];
            RAC(self, moneyLB.text) = [[RACObserve(self, cartModel.totalAmt) map:^id(id value) {
                return [NSString stringWithFormat:@"¥%@", value];
            }] takeUntil:self.rac_prepareForReuseSignal];
            RAC(self, backTimeLB.text) = [[RACObserve(self, cartModel.travel.returnTime) map:^id(id value) {
                return [NSString stringWithFormat:@"返回时间%@", value];
            }] takeUntil:self.rac_prepareForReuseSignal];
            
        } else if ([viewModel isKindOfClass:[MSFMyOrderListProductsViewModel class]]) {
            self.viewModel = viewModel;
            self.cmdViewModel = self.viewModel.cmdtyList[self.indexPath.row];
            
            RAC(self, titleLB.text) = [[RACObserve(self, cmdViewModel.cmdtyName) ignore:nil] takeUntil:self.rac_prepareForReuseSignal];
            RAC(self, goTimeLB.text) = [RACObserve(self, viewModel.orderTravelDto.departureTime) takeUntil:self.rac_prepareForReuseSignal];
            RAC(self, moneyLB.text) = [RACObserve(self, viewModel.totalAmt) takeUntil:self.rac_prepareForReuseSignal];
            RAC(self, backTimeLB.text) = [RACObserve(self, viewModel.orderTravelDto.returnTime) takeUntil:self.rac_prepareForReuseSignal];
        }
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(id)viewModel atIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    self.myViewModel = viewModel;
	
}

@end
