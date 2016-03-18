//
//  MSFCertificateCell.m
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFInventoryTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIColor+Utils.h"
#import "MSFElementViewModel.h"

@interface MSFInventoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger separatorType;
@property (nonatomic, assign) BOOL firstLine;
@property (nonatomic, assign) BOOL lastLine;
@property (nonatomic, strong) MSFElementViewModel *viewModel;

@end

@implementation MSFInventoryTableViewCell

- (void)bindViewModel:(MSFElementViewModel *)viewModel {
	_viewModel = viewModel;
	_markImageView.hidden = !viewModel.isCompleted;
	_titleLabel.text = viewModel.title;
	[_iconImageView setImageWithURL:viewModel.thumbURL placeholderImage:[UIImage imageNamed:@"photoUpload_placeholder.png"]];
	[self setNeedsDisplay];
}

- (void)drawSeparatorAtIndex:(NSIndexPath *)indexPath total:(NSInteger)total {
	
	if (indexPath.row == 0 || indexPath.row == 1) {
		_firstLine = YES;
	} else {
		_firstLine = NO;
	}
	
	if (total % 2 == 0 && (indexPath.row == total - 1 || indexPath.row == total - 2)) {
		_lastLine = YES;
	} else if (total % 2 == 1 && indexPath.row == total - 1) {
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
	
	if (_firstLine) {
		CGContextMoveToPoint(context, 0, 0);
		CGContextAddLineToPoint(context, rect.size.width, 0);
	}
	
	if (_lastLine) {
		CGContextMoveToPoint(context, 0, rect.size.height);
		CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
	}
	
	if (_separatorType == 0) {
		if (!_lastLine) {
			CGContextMoveToPoint(context, 0, rect.size.height - 0.5);
			CGContextAddLineToPoint(context, rect.size.width - 10, rect.size.height - 0.5);
		}
	} else {
		if (!_lastLine) {
			CGContextMoveToPoint(context, 10, rect.size.height - 0.5);
			CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 0.5);
		}
	}

	switch (_separatorType) {
		case 1: {
			CGContextMoveToPoint(context, rect.size.width - 0.5, 10);
			CGContextAddLineToPoint(context, rect.size.width - 0.5, rect.size.height);
			break;
		}
		case 2: {
			CGContextMoveToPoint(context, rect.size.width - 0.5, 0);
			CGContextAddLineToPoint(context, rect.size.width - 0.5, rect.size.height - 10);
			break;
		}
		case 3: {
			CGContextMoveToPoint(context, rect.size.width - 0.5, 0);
			CGContextAddLineToPoint(context, rect.size.width - 0.5, rect.size.height);
			break;
		}
		default:break;
	}
	
	CGContextSetLineWidth(context, 0.5);
	[[UIColor borderColor] setStroke];
	CGContextStrokePath(context);
}

@end
