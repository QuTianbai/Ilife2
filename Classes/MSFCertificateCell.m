//
//  MSFCertificateCell.m
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFCertificateCell.h"
#import "UIColor+Utils.h"

@interface MSFCertificateCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) NSInteger separatorType;
@property (nonatomic, assign) BOOL lastLine;

@end

@implementation MSFCertificateCell

- (void)drawSeparatorAtIndex:(NSIndexPath *)indexPath total:(NSInteger)total {
	
	if (total % 2 == 0 && (indexPath.row == total - 1 || indexPath.row == total - 2)) {
		_lastLine = YES;
	} else if	(total % 2 == 1 && indexPath.row == total - 1) {
		_lastLine = YES;
	} else {
		_lastLine = NO;
	}
	
	BOOL shouldDraw = indexPath.row % 2 == 0;
	if (!shouldDraw) {
		_separatorType = 0;
		return;
	}
	
	if (indexPath.row == 0) {
		_separatorType = 1;
	} else if (indexPath.row == total - 1 || indexPath.row == total - 2) {
		_separatorType = 2;
	} else {
		_separatorType = 3;
	}
	
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (_separatorType == 0) {
		CGContextMoveToPoint(context, 0, rect.size.height - 1);
		CGContextAddLineToPoint(context, rect.size.width - 10, rect.size.height - 1);
//		if () {
//			<#statements#>
//		}
	} else {
		CGContextMoveToPoint(context, 10, rect.size.height - 1);
		CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 1);
	}

	switch (_separatorType) {
		case 1: {
			CGContextMoveToPoint(context, rect.size.width - 1, 10);
			CGContextAddLineToPoint(context, rect.size.width - 1, rect.size.height);
			break;
		}
		case 2: {
			CGContextMoveToPoint(context, rect.size.width - 1, 0);
			CGContextAddLineToPoint(context, rect.size.width - 1, rect.size.height - 10);
			break;
		}
		case 3: {
			CGContextMoveToPoint(context, rect.size.width - 1, 0);
			CGContextAddLineToPoint(context, rect.size.width - 1, rect.size.height);
			break;
		}
		default:break;
	}
	
	CGContextSetLineWidth(context, 1);
	[[UIColor borderColor] setStroke];
	CGContextStrokePath(context);
}

@end
