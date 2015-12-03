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

#import "MSFUserInfoCircleView.h"
#import "MSFHomePageContentView.h"

#import "MSFHomePageCellModel.h"
#import "MSFHomepageViewModel.h"

#import "UILabel+AttributeColor.h"
#import "UIColor+Utils.h"
#import "MSFClient.h"
#import "MSFUser.h"

@interface MSFHomePageContentCollectionViewCell ()

@property (strong, nonatomic) MSFUserInfoCircleView *circleView;
@property (strong, nonatomic) MSFHomePageContentView *content;

@end

@implementation MSFHomePageContentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_content = [[MSFHomePageContentView alloc] init];
		_circleView = [[MSFUserInfoCircleView alloc] init];
		_circleView.show = YES;
		
		[self.contentView addSubview:_content];
		[self.contentView addSubview:_circleView];
		
		[_content mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.contentView);
		}];
		[_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(self.contentView);
			make.width.equalTo(self.circleView.mas_height);
			make.width.equalTo(self.contentView).multipliedBy(0.8).priorityMedium();
			make.top.greaterThanOrEqualTo(self.contentView);
			make.bottom.lessThanOrEqualTo(self.contentView);
		}];
	}
	return self;
}

- (void)bindViewModel:(id)viewModel {
	if ([viewModel isKindOfClass:MSFHomepageViewModel.class]) {
		MSFHomepageViewModel *vm = viewModel;
		[self placeholderShow:YES];
		MSFUser *user = vm.services.httpClient.user;
		[self.circleView setCompeltionStatus:user.complateCustInfo];
		[[[_circleView.clickCommand.executionSignals switchToLatest] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *x) {
			[vm pushInfo:x.integerValue];
		}];
	}
	if ([viewModel isKindOfClass:MSFHomePageCellModel.class]) {
		MSFHomePageCellModel *vm = viewModel;
		[self placeholderShow:NO];
		[_content updateWithModel:vm];
		[[_content.statusSignal takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
			if (vm.jumpDes == MSFHomePageDesContract) {
				[[NSNotificationCenter defaultCenter] postNotificationName:@"HOMEPAGECONFIRMCONTRACT" object:nil];
			} else {
				[viewModel pushDetailViewController];
			}
		}];
	}
}

- (void)placeholderShow:(BOOL)b {
	if (b) {
		if (!_circleView.show) {
			self.circleView.transform = CGAffineTransformMakeScale(0.6, 0.6);
			[UIView animateWithDuration:0.25 animations:^{
				self.content.alpha = 0;
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
					self.circleView.alpha = 1;
					self.circleView.transform = CGAffineTransformIdentity;
				} completion:^(BOOL finished) {
					self.circleView.show = YES;
				}];
			}];
		}
	} else {
		if (_circleView.show) {
			[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
				self.circleView.transform = CGAffineTransformMakeScale(0.6, 0.6);
				self.circleView.alpha = 0;
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.25 animations:^{
					self.content.alpha = 1;
				} completion:^(BOOL finished) {
					self.circleView.show = NO;
				}];
			}];
		}
	}
}

@end
