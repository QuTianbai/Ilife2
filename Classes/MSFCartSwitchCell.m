//
//  MSFCartSwitchCell.m
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCartSwitchCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "MSFCartViewModel.h"

@implementation MSFCartSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *label = [[UILabel alloc] init];
		label.font = [UIFont systemFontOfSize:15];
		label.text = @"是否加入寿险计划";
		[self.contentView addSubview:label];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setBackgroundImage:[UIImage imageNamed:@"icon-cloze-question.png"] forState:UIControlStateNormal];
		button.tag = 101;
		[self.contentView addSubview:button];

		UISwitch *switchInsurance = [[UISwitch alloc] init];
		switchInsurance.on = YES;
		switchInsurance.tag = 102;
		[self.contentView addSubview:switchInsurance];
		
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(15);
			make.centerY.equalTo(self.contentView);
		}];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(label.mas_right).offset(5);
			make.centerY.equalTo(self.contentView);
			make.width.height.equalTo(@20);
		}];
		[switchInsurance mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).offset(-8);
			make.centerY.equalTo(self.contentView);
		}];
	}
	return self;
}

- (void)bindViewModel:(MSFCartViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath {
	UIButton *button = (UIButton *)[self.contentView viewWithTag:101];
	UISwitch *switchInsurance = (UISwitch *)[self.contentView viewWithTag:102];
	button.rac_command = viewModel.executeInsuranceCommand;
	RACChannelTerminal *insurance = RACChannelTo(viewModel, joinInsurance);
	RAC(switchInsurance, on) = insurance;
	[[switchInsurance.rac_newOnChannel takeUntil:self.rac_prepareForReuseSignal] subscribe:insurance];
}

@end
