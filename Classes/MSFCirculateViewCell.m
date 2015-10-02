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

@property (nonatomic, strong) NSString *usableLimit;
@property (nonatomic, strong) NSString *usedLimit;
@property (nonatomic, strong) NSString *repayment;
@property (nonatomic, strong) NSString *overDue;

@end

@implementation MSFCirculateViewCell

- (void)awakeFromNib {
	_separatorLoc = 178.f;
	_unitWidth = 60.f;
}

- (void)bindViewModel:(MSFCirculateCashViewModel *)viewModel {
	_usableLimit = viewModel.usableLimit;
	_usedLimit = viewModel.usedLimit;
	_repayment = viewModel.latestDueMoney;
	_overDue = viewModel.overdueMoney;
	[_loanLimitView setAvailableCredit:_usableLimit usedCredit:_usedLimit];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, 0, _separatorLoc);
	CGContextAddLineToPoint(context, rect.size.width, _separatorLoc);
	CGContextMoveToPoint(context, rect.size.width / 2 - _unitWidth, _separatorLoc);
	CGContextMoveToPoint(context, rect.size.width / 2 - _unitWidth, _separatorLoc + _unitWidth);
	CGContextMoveToPoint(context, rect.size.width / 2 + _unitWidth, _separatorLoc + _unitWidth);
	CGContextMoveToPoint(context, rect.size.width / 2 + _unitWidth, _separatorLoc);
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
	NSDictionary *attri =@{NSForegroundColorAttributeName : textColor,
												 NSFontAttributeName :[UIFont systemFontOfSize: 17],
												 NSParagraphStyleAttributeName : paragraph};
	if (_overDue.length > 0) {
		[_overDue drawInRect:CGRectMake(rect.size.width / 2 - _unitWidth, _separatorLoc, _unitWidth * 2, _unitWidth / 2) withAttributes:attri];
	} else {
		[_repayment drawInRect:CGRectMake(rect.size.width / 2 - _unitWidth, _separatorLoc + _unitWidth / 2, _unitWidth * 2, _unitWidth / 2) withAttributes:attri];
	}
}

@end
