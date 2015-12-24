//
//  MSFOrderEditSelectionCell.m
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFOrderEditSelectionCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "MSFOrderEditViewModel.h"

@implementation MSFOrderEditSelectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *label = [[UILabel alloc] init];
		label.font = [UIFont systemFontOfSize:15];
		label.text = @"首付比例";
		[self.contentView addSubview:label];
		
		UITextField *tf = [[UITextField alloc] init];
		tf.font = [UIFont systemFontOfSize:15];
		tf.tag = 100;
		tf.userInteractionEnabled = NO;
		tf.placeholder = @"请选择首付比例";
		[self.contentView addSubview:tf];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.backgroundColor = UIColor.clearColor;
		button.tag = 101;
		[self.contentView addSubview:button];
		
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(15);
			make.centerY.equalTo(self.contentView);
			make.width.equalTo(@80);
		}];
		[tf mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(label.mas_right).offset(20);
			make.right.equalTo(self.contentView).offset(-8);
			make.centerY.equalTo(self.contentView);
			make.height.equalTo(@30);
		}];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(label.mas_right).offset(20);
			make.right.equalTo(self.contentView).offset(-8);
			make.top.bottom.equalTo(self.contentView);
		}];
	}
	return self;
}

- (void)bindViewModel:(MSFOrderEditViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath {
	UITextField *tf = (UITextField *)[self.contentView viewWithTag:100];
	UIButton *button = (UIButton *)[self.contentView viewWithTag:101];
	RAC(tf, text) = [RACObserve(viewModel, downPmtPct) takeUntil:self.rac_prepareForReuseSignal];
	button.rac_command = viewModel.executeDownPmtPctCommand;
}

@end
