//
//  MSFSocialContentCell.m
//  Finance
//
//  Created by 赵勇 on 12/30/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFSocialContentCell.h"
#import <Masonry/Masonry.h>

@implementation MSFSocialContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *title = [[UILabel alloc] init];
		title.font = [UIFont systemFontOfSize:15];
		title.tag = 100;
	
		UITextField *tf = [[UITextField alloc] init];
		tf.font = [UIFont systemFontOfSize:14];
		tf.tag = 101;

		[self.contentView addSubview:title];
		[self.contentView addSubview:tf];
		
		[title mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(15);
			make.centerY.equalTo(self.contentView);
		}];
		[tf mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(100);
			make.right.equalTo(self.contentView).offset(-10);
			make.centerY.equalTo(self.contentView);
			make.height.equalTo(@30);
		}];
	}
	return self;
}

- (void)bindViewModel:(id)viewModel {
	UILabel *title = (UILabel *)[self.contentView viewWithTag:100];
	UITextField *tf = (UITextField *)[self.contentView viewWithTag:101];

}

@end
