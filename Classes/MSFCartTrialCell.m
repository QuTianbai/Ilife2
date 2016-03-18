//
//  MSFCartTrialCell.m
//  Finance
//
//  Created by 赵勇 on 12/24/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCartTrialCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "MSFCounterLabel.h"
#import "MSFCartViewModel.h"
#import "UIColor+Utils.h"
#import "MSFTrial.h"

@interface MSFCartTrialCell ()

@property (nonatomic, strong) MSFCartViewModel *viewModel;

@end

@implementation MSFCartTrialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *label1 = [[UILabel alloc] init];
		label1.font = [UIFont systemFontOfSize:12];
		label1.tag = 100;
		label1.numberOfLines = 0;
		[self.contentView addSubview:label1];
		
		UILabel *label2 = [[UILabel alloc] init];
		label2.font = [UIFont systemFontOfSize:25];
		label2.text = @"预计每期还款金额";
		label2.textColor = UIColor.themeColorNew;
		[self.contentView addSubview:label2];
		
		UILabel *label3 = [[UILabel alloc] init];
		label3.font = [UIFont systemFontOfSize:25];
		label3.textColor = UIColor.themeColorNew;
		label3.text = @"￥";
		[self.contentView addSubview:label3];
		
		MSFCounterLabel *label4 = [[MSFCounterLabel alloc] init];
		label4.font = [UIFont systemFontOfSize:25];
		label4.tag = 101;
		label4.textColor = UIColor.themeColorNew;
		[self.contentView addSubview:label4];

		[label1 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.contentView).offset(5);
			make.left.equalTo(self.contentView).offset(15);
			make.right.equalTo(self.contentView).offset(-8);
		}];
		[label2 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.contentView).offset(40);
			make.centerX.equalTo(self.contentView);
		}];
		[label4 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(label2.mas_bottom).offset(5);
			make.centerX.equalTo(self.contentView);
		}];
		[label3 mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(label2.mas_bottom).offset(5);
			make.right.equalTo(label4.mas_left);
		}];
	}
	return self;
}

- (void)bindViewModel:(MSFCartViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath {
	UILabel *label1 = (UILabel *)[self.contentView viewWithTag:100];
	MSFCounterLabel *label4 = (MSFCounterLabel *)[self.contentView viewWithTag:101];
	RAC(label1, text) = [[RACObserve(viewModel, trial.lifeInsuranceAmt) takeUntil:self.rac_prepareForReuseSignal] map:^id(id value) {
        float floatValue = [value floatValue];
        NSString *str = [NSString stringWithFormat:@"%.2f", floatValue];
		return [NSString stringWithFormat:@"此服务为可选增值服务，请仔细阅读后选择  寿险金额：￥%@", str ?: @"0"];
	}];
	[[RACObserve(viewModel, trial.loanFixedAmt) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSString *x) {
		if (x.doubleValue > 0) {
			label4.valueText = [NSString stringWithFormat:@"%.2f", x.floatValue];
		} else {
			label4.valueText = @"未知";
		}
	}];
}

@end
