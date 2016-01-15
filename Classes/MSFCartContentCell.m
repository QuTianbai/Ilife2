//
//  MSFCartContentCell.m
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCartContentCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "MSFCartViewModel.h"
#import "MSFCommodity.h"
#import "MSFCompanion.h"
#import "MSFTravel.h"

@implementation MSFCartContentCell

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
			make.width.equalTo(@90);
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
	if ([viewModel isKindOfClass:MSFCartViewModel.class]) {
		if (indexPath.row != 1) {
			return;
		}
		MSFCartViewModel *order = (MSFCartViewModel *)viewModel;
		label1.text = @"贷款金额";
		RAC(label2, text) = [RACObserve(order, loanAmt) takeUntil:self.rac_prepareForReuseSignal];
	} else {
		if ([viewModel isKindOfClass:[MSFCommodity class]]) {
			MSFCommodity *commodity = (MSFCommodity *)viewModel;
			switch (indexPath.row) {
				case 1:
					label1.text = @"商品名称";
					label2.text = commodity.cmdtyName;
					break;
				case 2:
					label1.text = @"商品单价";
					label2.text = commodity.cmdtyPrice;
					break;
				case 3:
					label1.text = @"商品数量";
					label2.text = commodity.pcsCount;
					break;
			}
		} else if ([viewModel isKindOfClass:[MSFTravel class]]) {
			MSFTravel *travel = (MSFTravel *)viewModel;
			switch (indexPath.row) {
				case 1:
					label1.text = @"商品名称";
					label2.text = [travel.origin stringByAppendingFormat:@"-%@", travel.destination];
					break;
				case 2:
					label1.text = @"出发时间";
					label2.text = travel.departureTime;
					break;
				case 3:
					label1.text = @"返回时间";
					label2.text = travel.returnTime;
					break;
				case 4:
					label1.text = @"是否需要签证";
					label2.text = travel.isNeedVisa;
					break;
				case 5:
					//TODO: 核对单价字段
					label1.text = @"商品单价";
					label2.text = @"显示商品单价";
					break;
				default:
					break;
			}
		} else if ([viewModel isKindOfClass:[NSArray class]]) {
			NSArray *companions = viewModel;
//			NSArray *titles = @[@"与申请人关系", @"姓名", @"身份证号", @"手机号"];
			[companions enumerateObjectsUsingBlock:^(MSFCompanion *obj, NSUInteger idx, BOOL * _Nonnull stop) {
				switch (indexPath.row % 4) {
					case 0:
						label1.text = @"与申请人关系";
						label2.text = obj.companRelationship;
						break;
					case 1:
						label1.text = @"姓名";
						label2.text = obj.companName;
						break;
					case 2:
						label1.text = @"身份证号";
						label2.text = obj.companCertId;
						break;
					case 3:
						label1.text = @"手机号";
						label2.text = obj.companCellphone;
						break;
					default:
						break;
				}
			}];
		}
	}
}

@end
