//
//  MSFCirculateViewCell.m
//  Finance
//
//  Created by 赵勇 on 10/2/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCirculateViewCell.h"
#import "MSFLoanLimitView.h"
#import "MSFHomePageCellModel.h"
#import "NSDictionary+MSFKeyValue.h"
#import "UIColor+Utils.h"

@interface MSFCirculateViewCell ()

@property (weak, nonatomic) IBOutlet MSFLoanLimitView *loanLimitView;

@property (nonatomic, assign) CGFloat unitWidth;
@property (nonatomic, assign) CGFloat textMargin;
@property (nonatomic, strong) UIFont  *textFont;

@property (nonatomic, strong) MSFHomePageCellModel *viewModel;
@property (nonatomic, strong) NSString *repayment;
@property (nonatomic, strong) NSString *overDue;

@end

@implementation MSFCirculateViewCell

- (void)awakeFromNib {
	_unitWidth = 60.f;
	_textFont = [UIFont systemFontOfSize:17];
	_textMargin = (_unitWidth - _textFont.lineHeight * 2) / 3;
}

- (void)bindViewModel:(MSFHomePageCellModel *)viewModel {
	_viewModel = viewModel;
	_repayment = [NSString stringWithFormat:@"￥%@", viewModel.latestDueMoney.length > 0 ? viewModel.latestDueMoney : @"0"];
	_overDue   = [NSString stringWithFormat:@"￥%@", viewModel.overdueMoney.length > 0 ? viewModel.overdueMoney : @"0"];
	[_loanLimitView setAvailableCredit:viewModel.usableLimit
													usedCredit:viewModel.usedLimit];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGFloat separator = CGRectGetMaxY(_loanLimitView.frame) + 5;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, 0, separator);
	CGContextAddLineToPoint(context, rect.size.width, separator);
	CGContextMoveToPoint(context, rect.size.width / 2 - _unitWidth, separator);
	CGContextAddLineToPoint(context, rect.size.width / 2 - _unitWidth, separator + _unitWidth);
	CGContextAddLineToPoint(context, rect.size.width / 2 + _unitWidth, separator + _unitWidth);
	CGContextAddLineToPoint(context, rect.size.width / 2 + _unitWidth, separator);
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
	if ([self.viewModel.contractStatus isEqualToString:@"C"]) {
		[@"已逾期" drawInRect:CGRectMake(rect.size.width / 2 - _unitWidth, separator + _textMargin, _unitWidth * 2, _unitWidth / 2) withAttributes:attri];
		[_overDue drawInRect:CGRectMake(rect.size.width / 2 - _unitWidth, separator + _textFont.lineHeight + _textMargin * 2, _unitWidth * 2, _unitWidth / 2) withAttributes:attri];
	} else {
		[@"下期还款" drawInRect:CGRectMake(rect.size.width / 2 - _unitWidth, separator + _textMargin, _unitWidth * 2, _unitWidth / 2) withAttributes:attri];
		[_repayment drawInRect:CGRectMake(rect.size.width / 2 - _unitWidth, separator + _textFont.lineHeight + _textMargin * 2, _unitWidth * 2, _unitWidth / 2) withAttributes:attri];
	}
}

@end
