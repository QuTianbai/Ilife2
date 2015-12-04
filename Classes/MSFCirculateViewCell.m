//
//  MSFCirculateViewCell.m
//  Finance
//
//  Created by 赵勇 on 10/2/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCirculateViewCell.h"
#import <Masonry/Masonry.h>
#import "MSFHomePageCellModel.h"
#import "MSFLoanLimitView.h"
#import "UIColor+Utils.h"

@interface MSFCirculateViewCell ()

@property (nonatomic, strong) MSFLoanLimitView *loanLimitView;
@property (nonatomic, strong) MSFHomePageCellModel *viewModel;

@end

@implementation MSFCirculateViewCell

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
		_loanLimitView = [[MSFLoanLimitView alloc] init];
		[self.contentView addSubview:_loanLimitView];
		[_loanLimitView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.greaterThanOrEqualTo(self.contentView).offset(5);
			make.bottom.lessThanOrEqualTo(self.contentView).offset(-70);
			make.centerX.equalTo(self.contentView);
			make.centerY.equalTo(self.contentView).offset(-30).priorityMedium();
			make.width.equalTo(self.contentView).multipliedBy(0.75).priorityMedium();
			make.height.equalTo(self.loanLimitView.mas_width).multipliedBy(0.854);
		}];
	}
	return self;
}

- (void)bindViewModel:(MSFHomePageCellModel *)viewModel {
	_viewModel = viewModel;
	[_loanLimitView setAvailableCredit:viewModel.usableLimit
													usedCredit:viewModel.usedLimit];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	
	CGFloat width = rect.size.width;
	UIFont *font = [UIFont systemFontOfSize:CGRectGetWidth(rect) * 0.047];
	CGFloat topLine = CGRectGetMaxY(_loanLimitView.frame) + 8;
	CGFloat margin = 5;
	CGFloat w = CGRectGetHeight(_loanLimitView.frame) * 0.375;//信息描述框半宽度
	CGFloat h = font.lineHeight * 2 + margin * 3;//信息描述框高度

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, 0, topLine);
	CGContextAddLineToPoint(context, width, topLine);
	CGContextMoveToPoint(context, width / 2 - w, topLine);
	CGContextAddLineToPoint(context, width / 2 - w, topLine + h);
	CGContextAddLineToPoint(context, width / 2 + w, topLine + h);
	CGContextAddLineToPoint(context, width / 2 + w, topLine);
	CGContextSetLineWidth(context, 0.5);
	[UIColor.lineColor setStroke];
	CGContextStrokePath(context);
	
	NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
	paragraph.alignment = NSTextAlignmentCenter;
	NSMutableDictionary *attri = [NSMutableDictionary dictionary];
	[attri setObject:font forKey:NSFontAttributeName];
	[attri setObject:paragraph forKey:NSParagraphStyleAttributeName];
	CGRect rect1 = CGRectMake(width / 2 - w, topLine + margin, w * 2, font.lineHeight);
	CGRect rect2 = CGRectMake(width / 2 - w, topLine + font.lineHeight + margin * 2, w * 2, font.lineHeight);
	if ([self.viewModel.statusString isEqualToString:@"已逾期"]) {
		[attri setObject:UIColor.overDueTextColor
							forKey:NSForegroundColorAttributeName];
		[@"已逾期" drawInRect:rect1 withAttributes:attri];
		[_viewModel.overdueMoney drawInRect:rect2 withAttributes:attri];
	} else {
		[attri setObject:UIColor.repaymentTextColor
							forKey:NSForegroundColorAttributeName];
		[@"下期还款" drawInRect:rect1 withAttributes:attri];
		[_viewModel.latestDueMoney drawInRect:rect2 withAttributes:attri];
	}
}

@end
