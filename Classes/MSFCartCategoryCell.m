//
//  MSFCartCategoryCell.m
//  Finance
//
//  Created by 赵勇 on 12/24/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCartCategoryCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "MSFCommodity.h"

@implementation MSFCartCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *label1 = [[UILabel alloc] init];
		label1.font = [UIFont systemFontOfSize:15];
		label1.text = @"商品种类";
		[self.contentView addSubview:label1];
		
		UILabel *label2 = [[UILabel alloc] init];
		label2.font = [UIFont systemFontOfSize:15];
		label2.tag = 100;
		[self.contentView addSubview:label2];
		
		UILabel *label3 = [[UILabel alloc] init];
		label3.font = [UIFont systemFontOfSize:15];
		label3.tag = 101;
		[self.contentView addSubview:label3];
		
		[label1 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(15);
			make.centerY.equalTo(self.contentView);
			make.width.equalTo(@80);
		}];
		[label2 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(label1.mas_right).offset(20);
			make.centerY.equalTo(self.contentView);
		}];
		[label3 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(label2.mas_right).offset(8);
			make.right.equalTo(self.contentView).offset(-8);
			make.centerY.equalTo(self.contentView);
			make.width.equalTo(label2.mas_width);
		}];
	}
	return self;
}

- (void)bindViewModel:(MSFCommodity *)viewModel atIndexPath:(NSIndexPath *)indexPath {
	UILabel *label2 = (UILabel *)[self.contentView viewWithTag:100];
	UILabel *label3 = (UILabel *)[self.contentView viewWithTag:101];
#warning mock data
	label2.text = @"家电";
	label3.text = @"冰箱";
}

@end
