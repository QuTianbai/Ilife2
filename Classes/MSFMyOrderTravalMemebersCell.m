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

@interface MSFMyOrderTravalMemebersCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *mobileLB;
@property (weak, nonatomic) IBOutlet UILabel *identifyCardLB;
@property (weak, nonatomic) IBOutlet UILabel *isMarkLB;
@property (nonatomic, strong) MSFMyOrderListProductsViewModel *viewModel;
@property (nonatomic, strong) MSFCompanInfoListViewModel *memeberViewModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation MSFMyOrderTravalMemebersCell

- (void)awakeFromNib {
	RAC(self, memeberViewModel) = [RACObserve(self, viewModel) map:^id(MSFMyOrderListProductsViewModel *value) {
		return value.travelCompanInfoList[self.indexPath.row - 1];
	}];
	RAC(self, nameLB.text) = RACObserve(self, memeberViewModel.companName);
	RAC(self, mobileLB.text) = RACObserve(self, memeberViewModel.companCellphone);
	RAC(self, identifyCardLB.text) = RACObserve(self, memeberViewModel.companCertId);
	RAC(self, isMarkLB.text) = [RACObserve(self, viewModel.orderTravelDto.isNeedVisa) map:^id(NSString *value) {
		if ([value isEqualToString:@"1"]) {
			return @"需要签证";
		}
		return @"不需要签证";
	}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

}

- (void)bindViewModel:(id)viewModel atIndexPath:(NSIndexPath *)indexPath {
	self.viewModel = viewModel;
	self.indexPath = indexPath;
}

@end
