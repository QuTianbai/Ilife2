//
//  MSFHomePageContentCollectionViewCell.m
//  Finance
//
//  Created by 赵勇 on 7/29/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFHomePageContentCollectionViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <Masonry/Masonry.h>

#import "MSFTabBarController.h"
#import "MSFUserInfoCircleView.h"

#import "MSFLoanViewModel.h"
#import "MSFAddressViewModel.h"
#import "MSFPersonalViewModel.h"
#import "MSFProfessionalViewModel.h"
#import "MSFRelationshipViewModel.h"
#import "MSFTabBarViewModel.h"
#import "MSFFormsViewModel.h"

#import "UILabel+AttributeColor.h"
#import "UIColor+Utils.h"
#import "MSFClient.h"
#import "MSFUser.h"

@interface MSFHomePageContentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet MSFUserInfoCircleView *circleView;
@property (weak, nonatomic) IBOutlet UIButton *ConFirmContractBT;

@property (assign, nonatomic) BOOL circleShow;

@end

@implementation MSFHomePageContentCollectionViewCell

- (void)awakeFromNib {
	_statusButton.layer.cornerRadius = 5;
	_statusButton.layer.borderColor = UIColor.tintColor.CGColor;
	_statusButton.layer.borderWidth = 1;
	_circleView.alpha = 1;
	_content.alpha = 0;
	_circleShow = YES;
	@weakify(self)
	[[_circleView.clickCommand.executionSignals switchToLatest]
	 subscribeNext:^(NSNumber *x) {
		 @strongify(self)
		 [self onClickCircle:x.integerValue];
	 }];
}

- (void)onClickCircle:(NSInteger)index {
	MSFTabBarController *tabbarController = (MSFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
	id<MSFViewModelServices>services = tabbarController.viewModel.services;
	switch (index) {
		case 0: {
			
//			MSFLoanViewModel *viewModel1 = [[MSFLoanViewModel alloc] init];
//			viewModel1.type = @"SSS";
//			[services pushViewModel:viewModel1];
//			return;
			MSFPersonalViewModel *viewModel = [[MSFPersonalViewModel alloc] initWithFormsViewModel:tabbarController.viewModel.formsViewModel];
			[services pushViewModel:viewModel];
			break;
		}
		case 1: {
			MSFRelationshipViewModel *viewModel = [[MSFRelationshipViewModel alloc] initWithFormsViewModel:tabbarController.viewModel.formsViewModel];
			[services pushViewModel:viewModel];
			break;
		}
		case 2: {
			MSFProfessionalViewModel *viewModel = [[MSFProfessionalViewModel alloc] initWithFormsViewModel:tabbarController.viewModel.formsViewModel];
			[services pushViewModel:viewModel];
			break;
		}
	}
}

- (void)bindViewModel:(MSFLoanViewModel *)viewModel {
	if (viewModel) {
		[self placeholderShow:NO];
		if ([viewModel.type isEqualToString:@"APPLY"]) {
			_titleLabel.text  = viewModel.title;
			[_statusButton setTitle:viewModel.applyStatus forState:UIControlStateNormal];
			_amountLabel.text = viewModel.money;
			_infoLabel.text = [NSString stringWithFormat:@"%@   |   %@个月", viewModel.applyTime, viewModel.loanTerm];
			[[[_statusButton rac_signalForControlEvents:UIControlEventTouchUpInside]
				takeUntil:self.rac_prepareForReuseSignal]
			 subscribeNext:^(UIButton *x) {
				 if ([x.titleLabel.text isEqualToString:@"审核中"] || [x.titleLabel.text isEqualToString:@"审核未通过"] || [x.titleLabel.text isEqualToString:@"待放款"] || [x.titleLabel.text isEqualToString:@"已取消"] || [x.titleLabel.text isEqualToString:@"已还款"]) {
					 [viewModel pushDetailViewController];
				 } else if ([x.titleLabel.text isEqualToString:@"确认合同"]) {
					 [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGECONFIRMCONTRACT" object:nil];
				 }
			 }];
		} else {
			_titleLabel.text  = viewModel.title;
			[_statusButton setTitle:viewModel.contractStatus forState:UIControlStateNormal];
			_amountLabel.text = viewModel.money;
			if ([viewModel.contractStatus isEqualToString:@"还款中"]) {
				_infoLabel.text = [NSString stringWithFormat:@"本期还款截止日期\n%@", viewModel.currentPeriodDate];
			} else if ([viewModel.contractStatus isEqualToString:@"已逾期"]) {
				[_infoLabel setText:@"您的合同已逾期\n请及时联系客服还款：400-036-8876" highLightText:@"已逾期" highLightColor:[UIColor themeColorNew]];
			} else {
				_infoLabel.text = nil;
			}
			[[[_statusButton
				 rac_signalForControlEvents:UIControlEventTouchUpInside]
				takeUntil:self.rac_prepareForReuseSignal]
			 subscribeNext:^(UIButton *x) {
				 if ([x.titleLabel.text isEqualToString:@"还款中"] || [x.titleLabel.text isEqualToString:@"已逾期"]) {
					 [viewModel pushDetailViewController];
				 }
			 }];
		}
	} else {
		[self.circleView setCompeltionStatus:@""];
		[self placeholderShow:YES];
	}
	
	//self.ConFirmContractBT.hidden = YES;
	self.statusButton.hidden = NO;
//	[[self.ConFirmContractBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//		 [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGECONFIRMCONTRACT" object:nil];
//	 }];
	
//	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"MSFREQUESTCONTRACTSNOTIFACATIONSHOWBT" object:nil] subscribeNext:^(id x) {
//		self.ConFirmContractBT.hidden = NO;
//		self.statusButton.hidden = YES;
//	}];
	
//	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"MSFREQUESTCONTRACTSNOTIFACATIONHIDDENBT" object:nil] subscribeNext:^(id x) {
//		self.ConFirmContractBT.hidden = YES;
//		self.statusButton.hidden = NO;
//	}];
}

- (void)placeholderShow:(BOOL)b {
	[self bringSubviewToFront:self.circleView];
	if (b) {
		if (!_circleShow) {
			_circleShow = YES;
			self.circleView.transform = CGAffineTransformMakeScale(0.6, 0.6);
			[UIView animateWithDuration:0.25 animations:^{
				self.content.alpha = 0;
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					self.circleView.alpha = 1;
					self.circleView.transform = CGAffineTransformIdentity;
				} completion:nil];
			}];
		}
	} else {
		if (_circleShow) {
			_circleShow = NO;
			[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
				self.circleView.alpha = 0.5;
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.2 animations:^{
					self.circleView.alpha = 0;
					self.content.alpha = 1;
				} completion:nil];
			}];
		}
	}
}

@end
