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
@property (copy, nonatomic) void (^summaryBlock) ();

@end

@implementation MSFPhotosUploadHeaderView

- (void)awakeFromNib {
	_displayImageView.layer.cornerRadius = 5;
}

- (void)bindModel:(MSFElementViewModel *)viewModel shouldFold:(BOOL)sFold folded:(BOOL)folded {
	_viewModel = viewModel;
	[_displayImageView
	 setImageWithURL:viewModel.element.sampleURL
	 placeholderImage:[UIImage imageNamed:@"photoUpload_placeholder.png"]];
	if (folded) {
		_contentLabel.numberOfLines = 2;
		[_foldButton setTitle:@"展开" forState:UIControlStateNormal];
	} else {
		_contentLabel.numberOfLines = 0;
		[_foldButton setTitle:@"收起" forState:UIControlStateNormal];
	}
	
	_foldButton.hidden = !sFold;
	
	_contentLabel.text = viewModel.element.comment;
	
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
