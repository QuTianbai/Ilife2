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
#import "UIColor+Utils.h"

@interface MSFCirculateViewCell ()

@property (weak, nonatomic) IBOutlet MSFLoanLimitView *loanLimitView;
@property (nonatomic, strong) MSFHomePageCellModel *viewModel;

@end

@implementation MSFCirculateViewCell

- (void)bindViewModel:(MSFHomePageCellModel *)viewModel {
	_viewModel = viewModel;
	[_loanLimitView setAvailableCredit:viewModel.usableLimit
													usedCredit:viewModel.usedLimit];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGFloat w0 = rect.size.width;
	CGFloat w1 = 60.f;
	UIFont *font = [UIFont systemFontOfSize:17.f];
	CGFloat l = CGRectGetMaxY(_loanLimitView.frame) + 5;
	CGFloat m = (w1 - font.lineHeight * 2) / 3;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, 0, l);
	CGContextAddLineToPoint(context, w0, l);
	CGContextMoveToPoint(context, w0 / 2 - w1, l);
	CGContextAddLineToPoint(context, w0 / 2 - w1, l + w1);
	CGContextAddLineToPoint(context, w0 / 2 + w1, l + w1);
	CGContextAddLineToPoint(context, w0 / 2 + w1, l);
	CGContextSetLineWidth(context, 0.5);
	[UIColor.lineColor setStroke];
	CGContextStrokePath(context);
	
	NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
	paragraph.alignment = NSTextAlignmentCenter;
	NSMutableDictionary *attri = [NSMutableDictionary dictionary];
	[attri setObject:font forKey:NSFontAttributeName];
	[attri setObject:paragraph forKey:NSParagraphStyleAttributeName];
	CGRect rect1 = CGRectMake(w0 / 2 - w1, l + m, w1 * 2, w1 / 2);
	CGRect rect2 = CGRectMake(w0 / 2 - w1, l + font.lineHeight + m * 2, w1 * 2, w1 / 2);
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
