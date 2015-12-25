//
//  MSFOrderEditInputCell.m
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFOrderEditInputCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "MSFOrderEditViewModel.h"

@implementation MSFOrderEditInputCell

- (void)dealloc {
	NSLog(@"MSFOrderEditInputCell dealloc");
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *label = [[UILabel alloc] init];
		label.font = [UIFont systemFontOfSize:15];
		label.text = @"首付金额";
		[self.contentView addSubview:label];
		
		UITextField *tf = [[UITextField alloc] init];
		tf.font = [UIFont systemFontOfSize:15];
		tf.tag = 100;
		[self.contentView addSubview:tf];
		
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
	}
	return self;
}

- (void)bindViewModel:(MSFOrderEditViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath {
	UITextField *tf = (UITextField *)[self.contentView viewWithTag:100];
	tf.placeholder = @"请填写首付金额";
	RACChannelTerminal *downPmtChannel = RACChannelTo(viewModel, downPmtAmt);
	RAC(tf, text) = downPmtChannel;
	[[tf.rac_textSignal takeUntil:self.rac_prepareForReuseSignal] subscribe:downPmtChannel];
}

@end
