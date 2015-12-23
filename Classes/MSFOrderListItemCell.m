//
//  MSFOrderListItemCell.m
//  Finance
//
//  Created by 赵勇 on 12/15/15.
//  Copyright © 2015 MaShang Consumer Finance Co., Ltd. All rights reserved.
//

#import "MSFOrderListItemCell.h"
#import <Masonry/Masonry.h>
#import "MSFCommodity.h"

@implementation MSFOrderListItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *title = [[UILabel alloc] init];
		title.font = [UIFont systemFontOfSize:15];
		title.tag = 100;
		[self.contentView addSubview:title];
		
		UILabel *content = [[UILabel alloc] init];
		content.font = [UIFont systemFontOfSize:15];
		content.tag = 101;
		[self.contentView addSubview:content];
		
		[title mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(15);
			make.centerY.equalTo(self.contentView);
		}];
		[content mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).offset(-15);
			make.centerY.equalTo(self.contentView);
		}];
	}
	return self;
}

- (void)bindViewModel:(MSFCommodity *)model {
	UILabel *title = (UILabel *)[self.contentView viewWithTag:100];
	UILabel *content = (UILabel *)[self.contentView viewWithTag:101];
	title.text = model.cmdtyName;
	content.text = [NSString stringWithFormat:@"￥%@×%@", model.cmdtyPrice, model.pcsCount];
}

@end
