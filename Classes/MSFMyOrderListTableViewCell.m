//
//  MSFMyOrderListTableViewCell.m
//  Finance
//
//  Created by xbm on 16/3/2.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderListTableViewCell.h"
#import "MSFMyOrderListViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFMyOrderListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *contractTitle;
@property (weak, nonatomic) IBOutlet UILabel *contractTime;
@property (weak, nonatomic) IBOutlet UILabel *contractStatus;
@property (weak, nonatomic) IBOutlet UILabel *cintractSubTitle;

@property (nonatomic, strong) MSFMyOrderListViewModel *viewModel;

@end

@implementation MSFMyOrderListTableViewCell

- (void)awakeFromNib {
	
	RAC(self, imgView.image) = RACObserve(self, viewModel.contractImg);
	RAC(self, contractTitle.text) = RACObserve(self, viewModel.contractTitile);
	RAC(self, contractTime.text) = RACObserve(self, viewModel.applyTime);
	RAC(self, cintractSubTitle.text) = RACObserve(self, viewModel.contractSubTitile);
	RAC(self, contractStatus.text) = RACObserve(self, viewModel.status);
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)bindViewModel:(id)viewModel {
	if ([viewModel isKindOfClass:MSFMyOrderListViewModel.class]) {
		self.viewModel = viewModel;
	}
}

@end
