//
//  MSFSocialInsuranceCell.m
//  Finance
//
//  Created by 赵勇 on 12/30/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFSocialInsuranceCell.h"
#import <Masonry/Masonry.h>

@implementation MSFSocialInsuranceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *title = [[UILabel alloc] init];
		title.font = [UIFont systemFontOfSize:15];
		title.text = @"是否加入寿险计划";
		
		UIImageView *icon = [[UIImageView alloc] init];
		icon.image = [UIImage imageNamed:@"icon-cloze-question.png"];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = 100;
		
		UISwitch *insuranceSwitch = [[UISwitch alloc] init];
		insuranceSwitch.tag = 101;
		
		[self.contentView addSubview:title];
		[self.contentView addSubview:icon];
		[self.contentView addSubview:button];
		[self.contentView addSubview:insuranceSwitch];
		
		[title mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(15);
			make.centerY.equalTo(self.contentView);
		}];
		[icon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(title.mas_right).offset(5);
			make.centerY.equalTo(self.contentView);
			make.width.height.equalTo(@20);
		}];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(title);
			make.right.equalTo(icon);
			make.top.bottom.equalTo(self.contentView);
		}];
		[insuranceSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).offset(-10);
			make.centerY.equalTo(self.contentView);
		}];
	}
	return self;
}

- (void)bindViewModel:(id)viewModel {
	UIButton *button = (UIButton *)[self.contentView viewWithTag:100];
	UISwitch *insuranceSwitch = (UISwitch *)[self.contentView viewWithTag:101];

}

@end
