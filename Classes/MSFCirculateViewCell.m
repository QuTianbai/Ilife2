//
//  MSFCirculateViewCell.m
//  Finance
//
//  Created by 赵勇 on 10/2/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCirculateViewCell.h"
#import "MSFLoanLimitView.h"
#import "MSFCirculateCashViewModel.h"
#import "UIColor+Utils.h"

@interface MSFCirculateViewCell ()

@property (weak, nonatomic) IBOutlet MSFLoanLimitView *loanLimitView;

@property (nonatomic, assign) CGFloat separatorLoc;
@property (nonatomic, assign) CGFloat unitWidth;
@property (nonatomic, assign) CGFloat textMargin;
@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong) NSString *usableLimit;
@property (nonatomic, strong) NSString *usedLimit;
@property (nonatomic, strong) NSString *repayment;
@property (nonatomic, strong) NSString *overDue;

@end

@implementation MSFCirculateViewCell

- (void)awakeFromNib {
	_separatorLoc = ([UIScreen mainScreen].bounds.size.width - 80) * 2 / 3 + 50;
	_unitWidth = 60.f;
	_textFont = [UIFont systemFontOfSize:17];
	_textMargin = (_unitWidth - _textFont.lineHeight * 2) / 3;
}

- (void)bindViewModel:(MSFCirculateCashViewModel *)viewModel {
	_usableLimit = viewModel.usableLimit;
	_usedLimit = viewModel.usedLimit;
	_repayment = [NSString stringWithFormat:@"￥%@",viewModel.latestDueMoney];
	_overDue = [NSString stringWithFormat:@"￥%@",viewModel.overdueMoney];
	[_loanLimitView setAvailableCredit:_usableLimit usedCredit:_usedLimit];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, 0, _separatorLoc);
	CGContextAddLineToPoint(context, rect.size.width, _separatorLoc);
	CGContextMoveToPoint(context, rect.size.width / 2 - _unitWidth, _separatorLoc);
	CGContextAddLineToPoint(context, rect.size.width / 2 - _unitWidth, _separatorLoc + _unitWidth);
	CGContextAddLineToPoint(context, rect.size.width / 2 + _unitWidth, _separatorLoc + _unitWidth);
	CGContextAddLineToPoint(context, rect.size.width / 2 + _unitWidth, _separatorLoc);
	CGContextSetLineWidth(context, 0.5);
	[[UIColor lineColor] setStroke];
	CGContextStrokePath(context);
	
	UIColor *textColor = nil;
	if (_overDue.length > 0) {
		textColor = [UIColor overDueTextColor];
	} else {
		textColor = [UIColor repaymentTextColor];
	}
	NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
	paragraph.alignment = NSTextAlignmentCenter;
	NSDictionary *attri = @{NSForegroundColorAttributeName : textColor,
												  NSFontAttributeName : _textFont,
												  NSParagraphStyleAttributeName : paragraph};
	if (_overDue.length > 0) {
		[@"已逾期" drawInRect:CGRectMake(rect.size.width / 2 - _unitWidth, _separatorLoc + _textMargin, _unitWidth * 2, _unitWidth / 2) withAttributes:attri];
		[_overDue drawInRect:CGRectMake(rect.size.width / 2 - _unitWidth, _separatorLoc + _textFont.lineHeight + _textMargin * 2, _unitWidth * 2, _unitWidth / 2) withAttributes:attri];
	} else {
		[@"下期还款" drawInRect:CGRectMake(rect.size.width / 2 - _unitWidth, _separatorLoc + _textMargin, _unitWidth * 2, _unitWidth / 2) withAttributes:attri];
		[_repayment drawInRect:CGRectMake(rect.size.width / 2 - _unitWidth, _separatorLoc + _textFont.lineHeight + _textMargin * 2, _unitWidth * 2, _unitWidth / 2) withAttributes:attri];
	}
	
}

@end
