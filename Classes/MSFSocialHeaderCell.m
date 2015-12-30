//
//  MSFSocialHeaderCell.m
//  Finance
//
//  Created by 赵勇 on 12/30/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFSocialHeaderCell.h"
#import <Masonry/Masonry.h>

@implementation MSFSocialHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *title = [[UILabel alloc] init];
		title.font = [UIFont systemFontOfSize:15];
		title.tag = 100;
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setTitle:@"删除" forState:UIControlStateNormal];
		[button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
		button.titleLabel.font = [UIFont systemFontOfSize:15];
		button.tag = 101;
		
		[self.contentView addSubview:title];
		[self.contentView addSubview:button];
		
		[title mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(15);
			make.centerY.equalTo(self.contentView);
		}];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).offset(-10);
			make.centerY.equalTo(self.contentView);
			make.height.equalTo(@30);
		}];
	}
	return self;
}

- (void)bindViewModel:(id)viewModel {
	UILabel *title = (UILabel *)[self.contentView viewWithTag:100];
	UIButton *bt = (UIButton *)[self.contentView viewWithTag:101];
	
}

@end
