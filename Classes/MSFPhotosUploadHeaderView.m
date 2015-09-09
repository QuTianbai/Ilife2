//
//  MSFPhotosUploadHeaderView.m
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFPhotosUploadHeaderView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MSFElementViewModel.h"
#import "MSFElement.h"
#import "UILabel+AttributeColor.h"
#import "UIColor+Utils.h"

@interface MSFPhotosUploadHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
@property (nonatomic, strong) MSFElementViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (copy, nonatomic) void (^summaryBlock) ();

@end

@implementation MSFPhotosUploadHeaderView

- (void)awakeFromNib {
	_displayImageView.layer.cornerRadius = 5;
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
	_summaryLabel.userInteractionEnabled = YES;
	[_summaryLabel addGestureRecognizer:tap];
}

- (void)tap {
	if (_summaryBlock) {
		_summaryBlock();
	}
}

- (void)bindModel:(MSFElementViewModel *)viewModel summaryBlock:(void (^)())summaryBlock{
	_summaryBlock = summaryBlock;
	_viewModel = viewModel;
	
	[_displayImageView setImageWithURL:viewModel.element.sampleURL  placeholderImage:[UIImage imageNamed:@"photoUpload_placeholder.png"]];
	NSString *content = viewModel.element.comment;
	if (content.length > 0) {
		if (viewModel.folded) {
			_summaryLabel.hidden = YES;
			_contentLabel.hidden = NO;
			_contentLabel.text = content;
		} else {
			_summaryLabel.hidden = NO;
			_contentLabel.hidden = YES;
			
			int length = floor(([UIScreen mainScreen].bounds.size.width - 40) / 12.f * 2) ;
			NSString *text = nil;
			if (content.length > length) {
    text = [NSString stringWithFormat:@"%@...展开", [content substringToIndex:length - 6]];
			}
			
			_summaryLabel setText:[] highLightText:<#(NSString *)#> highLightColor:[UIColor ]
		}
	} else {
		_summaryLabel.text = nil;
		_contentLabel.text = nil;
	}
	
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, 0, rect.size.height - 0.5);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 0.5);
	CGContextSetLineWidth(context, 0.5);
	[[UIColor borderColor] setStroke];
	CGContextStrokePath(context);
}

@end
