//
//  MSFOrderListHeaderCell.m
//  Finance
//
//  Created by 赵勇 on 12/15/15.
//  Copyright © 2015 MaShang Consumer Finance Co., Ltd. All rights reserved.
//

#import "MSFOrderListHeaderCell.h"
#import <Masonry/Masonry.h>
#import "MSFOrderDetail.h"
#import "UIColor+Utils.h"

@implementation MSFOrderListHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *orderNo = [[UILabel alloc] init];
		orderNo.font = [UIFont systemFontOfSize:13];
		orderNo.tag = 100;
		[self.contentView addSubview:orderNo];
		
		UILabel *status = [[UILabel alloc] init];
		status.font = [UIFont systemFontOfSize:13];
		status.tag = 101;
		[self.contentView addSubview:status];
		
		UILabel *time = [[UILabel alloc] init];
		time.font = [UIFont systemFontOfSize:13];
		time.tag = 102;
		[self.contentView addSubview:time];

		[orderNo mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(15);
			make.top.equalTo(self.contentView).offset(10);
		}];
		[status mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.contentView).offset(10);
			make.right.equalTo(self.contentView).offset(-15);
		}];
		[time mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(orderNo.mas_bottom).offset(10);
			make.left.equalTo(self.contentView).offset(15);
		}];
	}
	return self;
}

- (void)bindViewModel:(MSFOrderDetail *)model {
	const NSDictionary *map = @{
		@"0" : @"审核中",
		@"1" : @"审核已通过",
		@"2" : @"审核未通过",
		@"3" : @"待支付",
		@"4" : @"已支付",
		@"5" : @"已退货"
	};
	UILabel *orderNo = (UILabel *)[self.contentView viewWithTag:100];
	UILabel *status = (UILabel *)[self.contentView viewWithTag:101];
	UILabel *time = (UILabel *)[self.contentView viewWithTag:102];
	orderNo.text = [NSString stringWithFormat:@"订单%@", model.inOrderId];
	status.text = map[model.orderStatus];
	time.text = model.orderTime;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, 0, rect.size.height);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
	CGContextSetLineWidth(context, 0.5);
	[UIColor.borderColor set];
	CGContextStrokePath(context);
}

@end
