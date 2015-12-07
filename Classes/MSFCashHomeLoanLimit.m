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
		self.backgroundColor = UIColor.clearColor;
	
		_limitView = [[MSFLoanLimitView alloc] init];
		[self addSubview:_limitView];
		
		_withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_withdrawButton.backgroundColor = UIColor.clearColor;
		_withdrawButton.layer.borderColor = UIColor.borderColor.CGColor;
		_withdrawButton.layer.borderWidth = 1;
		[_withdrawButton setTitleColor:UIColor.borderColor forState:UIControlStateNormal];
		[_withdrawButton setTitle:@"提款" forState:UIControlStateNormal];
		_withdrawButton.titleLabel.font = [UIFont systemFontOfSize:15];
		_withdrawButton.layer.cornerRadius = 5;
		[self addSubview:_withdrawButton];
		
		_repayButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_repayButton.backgroundColor = UIColor.clearColor;
		_repayButton.layer.borderColor = UIColor.borderColor.CGColor;
		_repayButton.layer.borderWidth = 1;
		[_repayButton setTitleColor:UIColor.borderColor forState:UIControlStateNormal];
		[_repayButton setTitle:@"还款" forState:UIControlStateNormal];
		_repayButton.titleLabel.font = [UIFont systemFontOfSize:15];
		_repayButton.layer.cornerRadius = 5;
		[self addSubview:_repayButton];
		
		[_withdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.lessThanOrEqualTo(@(-5));
			make.height.equalTo(@35);
			make.left.equalTo(self).offset(40).priorityMedium();
			make.right.equalTo(self.mas_centerX).offset(-20);
			make.width.lessThanOrEqualTo(@120);
			make.top.equalTo(_limitView.mas_bottom).offset(15);
		}];
		[_repayButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.lessThanOrEqualTo(@(-5));
			make.height.equalTo(@35);
			make.left.equalTo(self.mas_centerX).offset(20);
			make.right.equalTo(self).offset(-40).priorityMedium();
			make.width.equalTo(_withdrawButton);
			make.top.equalTo(_limitView.mas_bottom).offset(15);
		}];
		[_limitView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.greaterThanOrEqualTo(self).offset(5);
			make.centerX.equalTo(self);
			make.centerY.equalTo(self).offset(-10).priorityMedium();
			make.width.equalTo(self).multipliedBy(0.6).priorityMedium();
			make.height.equalTo(_limitView.mas_width).multipliedBy(0.854);
		}];
	}
	return self;
}

- (void)setAvailableCredit:(NSString *)ac usedCredit:(NSString *)uc {
	[_limitView setAvailableCredit:ac usedCredit:uc];
}

@end
