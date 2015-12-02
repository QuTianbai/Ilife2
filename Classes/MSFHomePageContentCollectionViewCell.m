//
//  MSFHomePageContentCollectionViewCell.m
//  Finance
//
//  Created by 赵勇 on 7/29/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFHomePageContentCollectionViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

#import "MSFTabBarController.h"
#import "MSFUserInfoCircleView.h"

#import "MSFHomePageCellModel.h"
#import "MSFPersonalViewModel.h"
#import "MSFProfessionalViewModel.h"
#import "MSFRelationshipViewModel.h"
#import "MSFHomepageViewModel.h"
#import "MSFTabBarViewModel.h"
#import "MSFFormsViewModel.h"

#import "UILabel+AttributeColor.h"
#import "UIColor+Utils.h"
#import "MSFClient.h"
#import "MSFUser.h"

//#import "MSFHomePageContentView.h"

@interface MSFHomePageContentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *content;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet MSFUserInfoCircleView *circleView;
@property (weak, nonatomic) IBOutlet UIButton *ConFirmContractBT;

//@property (strong, nonatomic) MSFHomePageContentView *content1;

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
	
//	_content1 = [[MSFHomePageContentView alloc] init];
//	[self.contentView addSubview:_content1];
//	[_content1 mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(self.contentView);
//	}];
}

- (void)onClickCircle:(NSInteger)index {
	MSFTabBarController *tabbarController = (MSFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
	id<MSFViewModelServices>services = tabbarController.viewModel.services;
	switch (index) {
		case 0: {
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

- (void)bindViewModel:(MSFHomePageCellModel *)viewModel {
	//显示饼图
	if ([viewModel isKindOfClass:MSFHomepageViewModel.class]) {
		MSFUser *user = ((MSFHomepageViewModel *)viewModel).services.httpClient.user;
		[self.circleView setCompeltionStatus:user.complateCustInfo];
		[self placeholderShow:YES];
		self.statusButton.hidden = NO;
		return;
	}
	//显示马上金融
	[self placeholderShow:NO];
//	_content.hidden = YES;
//	[_content1 updateWithModel:viewModel];
//	[_content1.statusCommand.executionSignals subscribeNext:^(id x) {
//		if (viewModel.jumpDes == MSFHomePageDesContract) {
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGECONFIRMCONTRACT" object:nil];
//		} else {
//			[viewModel pushDetailViewController];
//		}
//		
//	}];
//	return;
	_titleLabel.text  = viewModel.title;
	[_statusButton setTitle:viewModel.statusString
								 forState:UIControlStateNormal];
	[self setInfoLabelString:viewModel];
	[[[_statusButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		takeUntil:self.rac_prepareForReuseSignal]
	 subscribeNext:^(UIButton *x) {
		 if (viewModel.jumpDes == MSFHomePageDesContract) {
			 [[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGECONFIRMCONTRACT" object:nil];
		 } else {
			 [viewModel pushDetailViewController];
		 }
	 }];
}

- (void)setInfoLabelString:(MSFHomePageCellModel *)model {
	switch (model.dateDisplay) {
		case MSFHomePageDateDisplayTypeApply:
			_amountLabel.text = model.money;
			_unitLabel.hidden = NO;
			_infoLabel.text = [NSString stringWithFormat:@"%@   |   %@个月", model.applyTime, model.loanTerm];
			break;
		case MSFHomePageDateDisplayTypeRepay:
			_amountLabel.text = model.money;
			_unitLabel.hidden = NO;
			_infoLabel.text = [NSString stringWithFormat:@"本期还款截止日期\n%@", model.currentPeriodDate];
			break;
		case MSFHomePageDateDisplayTypeOverDue:
			_amountLabel.text = model.money;
			_unitLabel.hidden = NO;
			[_infoLabel setText:@"你的合同已逾期\n请及时联系客服还款：400-036-8876"
						highLightText:@"已逾期"
					 highLightColor:UIColor.tintColor];
			break;
		case MSFHomePageDateDisplayTypeProcessing:
			_amountLabel.text = nil;
			_unitLabel.hidden = YES;
			_infoLabel.text = @"合同正在处理中";
			break;
		case MSFHomePageDateDisplayTypeNone:
			_amountLabel.text = nil;
			_unitLabel.hidden = YES;
			_infoLabel.text = nil;
			break;
	}
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
