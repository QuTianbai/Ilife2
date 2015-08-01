//
//  MSFHomePageContentCollectionViewCell.m
//  Finance
//
//  Created by 赵勇 on 7/29/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFHomePageContentCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "MSFLoanViewModel.h"
#import "UIColor+Utils.h"
#import "UILabel+AttributeColor.h"

@interface MSFHomePageContentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *placeholder;
@property (assign, nonatomic) BOOL placeholderShow;

@end

@implementation MSFHomePageContentCollectionViewCell

- (void)awakeFromNib {
	_statusLabel.layer.cornerRadius = 5;
	_statusLabel.layer.borderColor = UIColor.tintColor.CGColor;
	_statusLabel.layer.borderWidth = 1;
	
	self.placeholder.alpha = 1;
	self.content.alpha = 0;
	self.placeholderShow = YES;
}

- (void)bindViewModel:(MSFLoanViewModel *)viewModel {
	if (viewModel) {
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
		[self placeholderShow:NO];
		return;
	}
	[self placeholderShow:YES];
}

- (void)placeholderShow:(BOOL)b {
	[self bringSubviewToFront:self.placeholder];
	if (b) {
		if (!self.placeholderShow) {
			self.placeholderShow = YES;
			self.placeholder.transform = CGAffineTransformMakeScale(0.6, 0.6);
			[UIView animateWithDuration:0.25 animations:^{
				self.content.alpha = 0;
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					self.placeholder.alpha = 1;
					self.placeholder.transform = CGAffineTransformIdentity;
				} completion:nil];
			}];
		}
	} else {
		if (self.placeholderShow) {
			self.placeholderShow = NO;
			[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
				self.placeholder.alpha = 0.5;
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.2 animations:^{
					self.placeholder.alpha = 0;
					self.content.alpha = 1;
				} completion:nil];
			}];
		}
	}
}

@end
