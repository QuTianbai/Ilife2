//
//  MSFHomePageContentCollectionViewCell.m
//  Finance
//
//  Created by 赵勇 on 7/29/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFHomePageContentCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "MSFTabBarController.h"

#import "MSFUserInfoCircleView.h"

#import "MSFLoanViewModel.h"
#import "MSFRepaymentViewModel.h"
#import "UIColor+Utils.h"
#import "UILabel+AttributeColor.h"

#import "MSFAddressViewModel.h"
#import "MSFPersonalViewModel.h"
#import "MSFProfessionalViewModel.h"
#import "MSFRelationshipViewModel.h"
#import "MSFTabBarViewModel.h"
#import "MSFFormsViewModel.h"

@interface MSFHomePageContentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet MSFUserInfoCircleView *circleView;
@property (assign, nonatomic) BOOL circleShow;
@property (weak, nonatomic) IBOutlet UIButton *ConFirmContractBT;

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
			MSFAddressViewModel *addrViewModel = [[MSFAddressViewModel alloc] initWithAddress:tabbarController.viewModel.formsViewModel.currentAddress services:services];
			MSFPersonalViewModel *viewModel = [[MSFPersonalViewModel alloc] initWithFormsViewModel:tabbarController.viewModel.formsViewModel addressViewModel:addrViewModel];
			[services pushViewModel:viewModel];
			break;
		}
		case 1: {
			MSFRelationshipViewModel *viewModel = [[MSFRelationshipViewModel alloc] initWithFormsViewModel:tabbarController.viewModel.formsViewModel];
			[services pushViewModel:viewModel];
			break;
		}
		case 2: {
			MSFAddressViewModel *addrViewModel = [[MSFAddressViewModel alloc] initWithAddress:tabbarController.viewModel.formsViewModel.currentAddress services:services];
			MSFProfessionalViewModel *viewModel = [[MSFProfessionalViewModel alloc] initWithFormsViewModel:tabbarController.viewModel.formsViewModel addressViewModel:addrViewModel];
			[services pushViewModel:viewModel];
			break;
		}
	}
}

- (void)bindViewModel:(id)viewModel {
	if (viewModel) {
		if ([viewModel isKindOfClass:MSFLoanViewModel.class]) {
			[self placeholderShow:NO];
			MSFLoanViewModel *model = viewModel;
			_titleLabel.text  = model.title;
			[_statusButton setTitle:model.status forState:UIControlStateNormal];
			_amountLabel.text = model.totalAmount;
			_infoLabel.text = [NSString stringWithFormat:@"%@   |   %@个月", model.applyDate, model.totalInstallments];
			[[[_statusButton rac_signalForControlEvents:UIControlEventTouchUpInside]
				takeUntil:self.rac_prepareForReuseSignal]
			 subscribeNext:^(NSString *x) {
				 if ([x isEqualToString:@"申请中"]) {
					 [model pushHistoryDetails];
				 }
			 }];
			return;
		} else if ([viewModel isKindOfClass:MSFRepaymentViewModel.class]) {
			MSFRepaymentViewModel *model = viewModel;
			if (model.repaymentStatus) {
				[self placeholderShow:NO];
				_titleLabel.text  = model.title;
				[_statusButton setTitle:model.status forState:UIControlStateNormal];
				_amountLabel.text = model.repaidAmount;
				if ([model.status isEqualToString:@"还款中"]) {
					_infoLabel.text = [NSString stringWithFormat:@"本期还款截止日期\n%@", model.expireDate];
				} else if ([model.status isEqualToString:@"已逾期"]) {
					[_infoLabel setText:@"您的合同已逾期\n请及时联系客服还款：400-036-8876" highLightText:@"已逾期" highLightColor:[UIColor themeColorNew]];
				} else {
					_infoLabel.text = nil;
				}
				[[[_statusButton
					 rac_signalForControlEvents:UIControlEventTouchUpInside]
					takeUntil:self.rac_prepareForReuseSignal]
				 subscribeNext:^(NSString *x) {
					 if ([x isEqualToString:@"还款中"] || [x isEqualToString:@"已逾期"]) {
						 [model pushRepaymentPlan];
					 }
				 }];
				return;
			}
		}
	}
	self.ConFirmContractBT.hidden = YES;
	self.statusButton.hidden = NO;
	[[self.ConFirmContractBT rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext:^(id x) {
		 //[SVProgressHUD showWithStatus:@"正在加载..."];
		 //		 self.ConFirmContractBT.hidden = YES;
		 //		 self.statusLabel.hidden = NO;
		 //NSLog(@"我是发通知");
		 [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGECONFIRMCONTRACT" object:nil];
		 
	 }];
	
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"MSFREQUESTCONTRACTSNOTIFACATIONSHOWBT" object:nil] subscribeNext:^(id x) {
		self.ConFirmContractBT.hidden = NO;
		self.statusButton.hidden = YES;
	}];
	
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"MSFREQUESTCONTRACTSNOTIFACATIONHIDDENBT" object:nil] subscribeNext:^(id x) {
		self.ConFirmContractBT.hidden = YES;
		self.statusButton.hidden = NO;
	}];
	
	[self placeholderShow:YES];
}
/*
 - (IBAction)onApply:(UIButton *)sender {
	MSFTabBarController *tab = (MSFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
	if ([tab isKindOfClass:MSFTabBarController.class]) {
 if ([tab.delegate tabBarController:tab shouldSelectViewController:tab.viewControllers[1]])
 tab.selectedIndex = 1;
	}
 }*/

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
