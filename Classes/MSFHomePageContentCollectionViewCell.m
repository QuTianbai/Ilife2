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
#import "MSFRepaymentViewModel.h"
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

- (void)bindViewModel:(id)viewModel {
	if (viewModel) {
		if ([viewModel isKindOfClass:MSFLoanViewModel.class]) {
			MSFLoanViewModel *model = viewModel;
			_titleLabel.text  = model.title;
			_statusLabel.text = model.status;
			_amountLabel.text = model.totalAmount;
			_infoLabel.text = [NSString stringWithFormat:@"%@   |   %@个月", model.applyDate, model.totalInstallments];
			[self placeholderShow:NO];
			return;
		} else if ([viewModel isKindOfClass:MSFRepaymentViewModel.class]) {
			MSFRepaymentViewModel *model = viewModel;
			if (model.repaymentStatus) {
				_titleLabel.text  = model.title;
				_statusLabel.text = model.status;
				_amountLabel.text = model.repaidAmount;
				if ([model.status isEqualToString:@"还款中"]) {
					_infoLabel.text = [NSString stringWithFormat:@"%@", model.expireDate];
				} else if ([model.status isEqualToString:@"已逾期"]) {
					[_infoLabel setText:@"您的合同已逾期\n请及时联系客服还款：400-036-8876" highLightText:@"已逾期" highLightColor:[UIColor themeColorNew]];
				} else {
					_infoLabel.text = nil;
				}
				[self placeholderShow:NO];
				return;
			}
		}
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
