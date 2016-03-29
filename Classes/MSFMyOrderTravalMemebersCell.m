//
//  MSFMyOrderTravalMemebersCell.m
//  Finance
//
//  Created by xbm on 16/3/8.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderTravalMemebersCell.h"
#import "MSFMyOrderListProductsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCompanInfoListViewModel.h"
#import "MSFCart.h"
#import "MSFTravel.h"

@interface MSFMyOrderTravalMemebersCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *mobileLB;
@property (weak, nonatomic) IBOutlet UILabel *identifyCardLB;
@property (weak, nonatomic) IBOutlet UILabel *isMarkLB;
@property (nonatomic, strong) MSFMyOrderListProductsViewModel *orderListviewModel;
@property (nonatomic, strong) MSFCompanInfoListViewModel *memeberViewModel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) MSFCart *cartModel;

@property (nonatomic, weak) id viewModel;

@end

@implementation MSFMyOrderTravalMemebersCell

- (void)awakeFromNib {
    @weakify(self)
    [RACObserve(self, viewModel) subscribeNext:^(id x) {
        @strongify(self)
        if ([x isKindOfClass:[MSFCart class]]) {
            self.cartModel = x;
            self.memeberViewModel = [[MSFCompanInfoListViewModel alloc] initWithModel:self.cartModel.companions[self.indexPath.row - 1]];
            RAC(self, nameLB.text) = [RACObserve(self, memeberViewModel.companName) takeUntil:self.rac_prepareForReuseSignal];
            RAC(self, mobileLB.text) = [RACObserve(self, memeberViewModel.companCellphone) takeUntil:self.rac_prepareForReuseSignal];
            RAC(self, identifyCardLB.text) = [RACObserve(self, memeberViewModel.companCertId) takeUntil:self.rac_prepareForReuseSignal];
            RAC(self, isMarkLB.text) = [[RACObserve(self, cartModel.travel.isNeedVisa) map:^id(NSString *value) {
                if ([value isEqualToString:@"1"]) {
                    return @"需要签证";
                }
                return @"不需要签证";
            }] takeUntil:self.rac_prepareForReuseSignal];
        } else if ([x isKindOfClass:[MSFMyOrderListProductsViewModel class]]) {
            self.orderListviewModel = x;
            self.memeberViewModel = self.orderListviewModel.travelCompanInfoList[self.indexPath.row - 1];
            RAC(self, nameLB.text) = [RACObserve(self, memeberViewModel.companName) takeUntil:self.rac_prepareForReuseSignal];
            RAC(self, mobileLB.text) = [RACObserve(self, memeberViewModel.companCellphone) takeUntil:self.rac_prepareForReuseSignal];
            RAC(self, identifyCardLB.text) = [RACObserve(self, memeberViewModel.companCertId) takeUntil:self.rac_prepareForReuseSignal];
            RAC(self, isMarkLB.text) = [[RACObserve(self, orderListviewModel.orderTravelDto.isNeedVisa) map:^id(NSString *value) {
                if ([value isEqualToString:@"1"]) {
                    return @"需要签证";
                }
                return @"不需要签证";
            }] takeUntil:self.rac_prepareForReuseSignal];
        }
    }];
    
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

}

- (void)bindViewModel:(id)viewModel atIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
	self.viewModel = viewModel;
	
}

@end
