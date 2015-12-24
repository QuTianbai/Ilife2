//
//  MSFOrderEditContentCell.m
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFOrderEditContentCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "MSFOrderEditViewModel.h"

@implementation MSFOrderEditContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *label1 = [[UILabel alloc] init];
		label1.font = [UIFont systemFontOfSize:15];
		label1.tag = 100;
		[self.contentView addSubview:label1];
		
		UILabel *label2 = [[UILabel alloc] init];
		label2.font = [UIFont systemFontOfSize:15];
		label2.tag = 101;
		[self.contentView addSubview:label2];
		
		[label1 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(15);
			make.centerY.equalTo(self.contentView);
			make.width.equalTo(@80);
		}];
		[label2 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(label1.mas_right).offset(20);
			make.right.equalTo(self.contentView).offset(-8);
			make.centerY.equalTo(self.contentView);
		}];
	}
	return self;
}

- (void)bindViewModel:(id)viewModel atIndexPath:(NSIndexPath *)indexPath {
	UILabel *label1 = (UILabel *)[self.contentView viewWithTag:100];
	UILabel *label2 = (UILabel *)[self.contentView viewWithTag:101];
	if ([viewModel isKindOfClass:MSFOrderEditViewModel.class]) {
		if (indexPath.row != 1) {
			return;
		}
		MSFOrderEditViewModel *order = (MSFOrderEditViewModel *)viewModel;
		label1.text = @"贷款金额";
		RAC(label2, text) = [RACObserve(order, loanAmt) takeUntil:self.rac_prepareForReuseSignal];
	} else {
		NSDictionary *commodity = (NSDictionary *)viewModel;
		switch (indexPath.row) {
			case 1:
				label1.text = @"商品名称";
				label2.text = commodity[@"name"];
				break;
			case 2:
				label1.text = @"商品单价";
				label2.text = commodity[@"price"];
				break;
			case 3:
				label1.text = @"商品数量";
				label2.text = commodity[@"num"];
				break;
		}
	}
}

@end
