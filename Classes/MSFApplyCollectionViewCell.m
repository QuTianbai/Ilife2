//
//  MSFApplyCollectionViewCell.m
//  Finance
//
//  Created by 赵勇 on 7/28/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFApplyCollectionViewCell.h"
#import "MSFLoanViewModel.h"
#import "UIColor+Utils.h"

@interface MSFApplyCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@end

@implementation MSFApplyCollectionViewCell

- (void)awakeFromNib {
	_statusLabel.layer.cornerRadius = 5;
	_statusLabel.layer.borderColor = UIColor.tintColor.CGColor;
	_statusLabel.layer.borderWidth = 1;
}

- (void) bindViewModel:(MSFLoanViewModel *)viewModel {
	_titleLabel.text = viewModel.title;
	_statusLabel.text = viewModel.status;
	_amountLabel.text = viewModel.totalAmount;
	_dateLabel.text = viewModel.applyDate;
	_statusLabel.text = viewModel.mothlyRepaymentAmount;
}

@end
