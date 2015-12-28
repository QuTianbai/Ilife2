//
//  MSFOrderListCell.m
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFOrderListCell.h"
#import <Masonry/Masonry.h>
#import "MSFInsetsLabel.h"
#import "MSFOrderDetail.h"
#import "UIColor+Utils.h"

@implementation MSFOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *title = [[UILabel alloc] init];
		title.font = [UIFont systemFontOfSize:15];
		title.tag = 100;
		[self.contentView addSubview:title];
		
		MSFInsetsLabel *content = [[MSFInsetsLabel alloc] init];
		content.tag = 101;
		[self.contentView addSubview:content];
		
		[title mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(15);
			make.top.bottom.equalTo(self.contentView);
		}];
		[content mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self.contentView);
			make.right.equalTo(self.contentView).offset(-15);
			make.height.equalTo(@30);
		}];
	}
	return self;
}

- (void)setTitle:(NSString *)title content:(NSString *)content isList:(BOOL)isList {
	UILabel *label1 = (UILabel *)[self.contentView viewWithTag:100];
	MSFInsetsLabel *label2 = (MSFInsetsLabel *)[self.contentView viewWithTag:101];
	NSString *validString = nil;
	if (content) {
		validString = [NSString stringWithFormat:@"%@", content];
	}
	label1.text = title;
	
	if (isList) {
		label2.text = validString;
		if ([title isEqualToString:@"商品信息"]) {
			self.contentView.backgroundColor = UIColor.darkBackgroundColor;
			label1.textColor = UIColor.themeColorNew;
			label2.textColor = [self colorWithStatus:content];
		} else {
			self.contentView.backgroundColor = UIColor.whiteColor;
			label1.textColor = UIColor.blackColor;
			label2.textColor = UIColor.blackColor;
		}
	} else {
		label2.text = validString;
		if ([title isEqualToString:@"订单状态"]) {
			label2.textColor = [self colorWithStatus:content];
			label2.backgroundColor = UIColor.clearColor;
		} else if ([title isEqualToString:@"贷款期数"]) {
			label2.backgroundColor = UIColor.lightGrayColor;
			label2.textColor = UIColor.whiteColor;
		} else {
			label2.backgroundColor = UIColor.clearColor;
			label2.textColor = UIColor.blackColor;
		}
		if ([title isEqualToString:@"姓名"]) {
			NSString *name = [validString stringByReplacingCharactersInRange:NSMakeRange(0, validString.length - 1) withString:@"*"];
			label2.text = name;
		} else if ([title isEqualToString:@"手机号"]) {
			NSString *phone = [validString stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
			label2.text = phone;
		} else {
			label2.text = validString;
		}
	}
}

- (UIColor *)colorWithStatus:(NSString *)status {
	return [UIColor redColor];
}

@end
