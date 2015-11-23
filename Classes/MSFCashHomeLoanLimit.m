//
//  MSFCashHomeLoanLimit.m
//  Finance
//
//  Created by 赵勇 on 11/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCashHomeLoanLimit.h"
#import <Masonry/Masonry.h>
#import "MSFLoanLimitView.h"
#import "UIColor+Utils.h"

@interface MSFCashHomeLoanLimit ()

@property (nonatomic, strong) MSFLoanLimitView *limitView;
@property (nonatomic, strong, readwrite) UIButton *withdrawButton;
@property (nonatomic, strong, readwrite) UIButton *repayButton;

@end

@implementation MSFCashHomeLoanLimit

- (instancetype)init {
	self = [super init];
	if (self) {
		self.backgroundColor = [UIColor blueColor];
		
		_limitView = [[MSFLoanLimitView alloc] init];
		[self addSubview:_limitView];
		
		_withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_withdrawButton.backgroundColor = UIColor.clearColor;
		_withdrawButton.layer.borderColor = UIColor.borderColor.CGColor;
		_withdrawButton.layer.borderWidth = 1;
		[_withdrawButton setTitleColor:UIColor.borderColor forState:UIControlStateNormal];
		[_withdrawButton setTitle:@"提现" forState:UIControlStateNormal];
		_withdrawButton.layer.cornerRadius = 5;
		[self addSubview:_withdrawButton];
		
		_repayButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_repayButton.backgroundColor = UIColor.clearColor;
		_repayButton.layer.borderColor = UIColor.borderColor.CGColor;
		_repayButton.layer.borderWidth = 1;
		[_repayButton setTitleColor:UIColor.borderColor forState:UIControlStateNormal];
		[_repayButton setTitle:@"提现" forState:UIControlStateNormal];
		_repayButton.layer.cornerRadius = 5;
		[self addSubview:_repayButton];
		
		[_limitView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.greaterThanOrEqualTo(self).offset(20);
			make.centerX.equalTo(self);
			make.centerY.equalTo(self).offset(-20);
			make.width.equalTo(self).multipliedBy(0.6).priorityMedium();
			make.height.equalTo(_limitView.mas_width).multipliedBy(0.854);
		}];
		[_withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(_limitView.mas_bottom).offset(20);
			make.left.equalTo(self).offset(40);
			make.height.equalTo(@40);
		}];
		[_repayButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(_limitView.mas_bottom).offset(20);
			make.left.equalTo(_withdrawButton.mas_right).offset(40);
			make.right.equalTo(self).offset(-40);
			make.height.equalTo(@40);
			make.width.equalTo(_withdrawButton);
		}];
	}
	return self;
}

- (void)setAvailableCredit:(NSString *)ac usedCredit:(NSString *)uc {
	[_limitView setAvailableCredit:@"6788" usedCredit:@"2334.56"];
}

@end
