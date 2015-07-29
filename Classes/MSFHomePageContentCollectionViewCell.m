//
//  MSFHomePageContentCollectionViewCell.m
//  Finance
//
//  Created by 赵勇 on 7/29/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFHomePageContentCollectionViewCell.h"
#import "MSFLoanViewModel.h"
#import "UIColor+Utils.h"
#import "UILabel+AttributeColor.h"

@interface MSFHomePageContentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation MSFHomePageContentCollectionViewCell

- (void)awakeFromNib {
	_statusLabel.layer.cornerRadius = 5;
	_statusLabel.layer.borderColor = UIColor.tintColor.CGColor;
	_statusLabel.layer.borderWidth = 1;
}

- (void)bindViewModel:(MSFLoanViewModel *)viewModel {
	_titleLabel.text  = viewModel.title;
	_statusLabel.text = viewModel.status;
	_amountLabel.text = viewModel.mothlyRepaymentAmount;
	
	if ([viewModel.status isEqualToString:@"审核中"]) {
		_infoLabel.text = [NSString stringWithFormat:@"%@   |   %@", viewModel.applyDate, viewModel.totalInstallments];
	} else if ([viewModel.status isEqualToString:@"已逾期"]) {
		[_infoLabel setText:[NSString stringWithFormat:@"您的合同已逾期   请及时还款www.msxf.com"] highLightText:@"已逾期" highLightColor:UIColor.tintColor];
	} else {
		_infoLabel.text = [NSString stringWithFormat:@"申请日期   %@", viewModel.applyDate];
	}
	 
}

@end
