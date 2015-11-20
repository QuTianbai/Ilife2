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
//@property (nonatomic, strong) MSFHomePageCellModel *viewModel;

@end

@implementation MSFCirculateViewCell

- (void)bindViewModel:(MSFHomePageCellModel *)viewModel {
	//_viewModel = viewModel;
	[_loanLimitView setAvailableCredit:@"3000"
													usedCredit:@"99999"];
	//[_loanLimitView setAvailableCredit:viewModel.usableLimit
											//		usedCredit:viewModel.usedLimit];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	
	CGFloat width = rect.size.width;
	CGFloat w = CGRectGetWidth(_loanLimitView.frame) * 3 / 16;//信息描述框半宽度
	UIFont *font = [UIFont systemFontOfSize:CGRectGetWidth(rect) * 0.047];
	CGFloat topLine = CGRectGetMaxY(_loanLimitView.frame) + 5;
	CGFloat margin = (w - font.lineHeight * 2) / 3;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, 0, topLine);
	CGContextAddLineToPoint(context, width, topLine);
	CGContextMoveToPoint(context, width / 2 - w, topLine);
	CGContextAddLineToPoint(context, width / 2 - w, topLine + w);
	CGContextAddLineToPoint(context, width / 2 + w, topLine + w);
	CGContextAddLineToPoint(context, width / 2 + w, topLine);
	CGContextSetLineWidth(context, 0.5);
	[UIColor.lineColor setStroke];
	CGContextStrokePath(context);
	
	NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
	paragraph.alignment = NSTextAlignmentCenter;
	NSMutableDictionary *attri = [NSMutableDictionary dictionary];
	[attri setObject:font forKey:NSFontAttributeName];
	[attri setObject:paragraph forKey:NSParagraphStyleAttributeName];
	CGRect rect1 = CGRectMake(width / 2 - w, topLine + margin, w * 2, w / 2);
	CGRect rect2 = CGRectMake(width / 2 - w, topLine + font.lineHeight + margin * 2, w * 2, w / 2);
//	if ([self.viewModel.statusString isEqualToString:@"已逾期"]) {
//		[attri setObject:UIColor.overDueTextColor
//							forKey:NSForegroundColorAttributeName];
//		[@"已逾期" drawInRect:rect1 withAttributes:attri];
//		[_viewModel.overdueMoney drawInRect:rect2 withAttributes:attri];
//	} else {
		[attri setObject:UIColor.repaymentTextColor
							forKey:NSForegroundColorAttributeName];
		[@"下期还款" drawInRect:rect1 withAttributes:attri];
		[@"￥69" drawInRect:rect2 withAttributes:attri];
		//_viewModel.latestDueMoney
	//}
}

@end
