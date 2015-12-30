//
//  MSFOrderListFooterCell.m
//  Finance
//
//  Created by 赵勇 on 12/15/15.
//  Copyright © 2015 MaShang Consumer Finance Co., Ltd. All rights reserved.
//

#import "MSFOrderListFooterCell.h"
#import <Masonry/Masonry.h>
#import "MSFOrderDetail.h"

@implementation MSFOrderListFooterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		UILabel *content = [[UILabel alloc] init];
		content.font = [UIFont systemFontOfSize:13];
		content.tag = 100;
		[self.contentView addSubview:content];

		[content mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.bottom.equalTo(self.contentView);
			make.right.equalTo(self.contentView).offset(-15);
		}];
	}
	return self;
}

- (void)bindViewModel:(MSFOrderDetail *)model {
	UILabel *content = (UILabel *)[self.contentView viewWithTag:100];
	content.text = [NSString stringWithFormat:@"共%@件商品，合计：￥%@元", model.totalQuantity, model.totalAmt];
}

@end
