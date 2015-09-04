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

#import "UIColor+Utils.h"

@interface MSFPhotosUploadHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
@property (nonatomic, strong) MSFElementViewModel *viewModel;

@end

@implementation MSFPhotosUploadHeaderView

- (void)awakeFromNib {
	_displayImageView.layer.cornerRadius = 5;
}

- (void)bindModel:(MSFElementViewModel *)viewModel {
	_viewModel = viewModel;
	[_displayImageView setImageWithURL:viewModel.element.sampleURL  placeholderImage:[UIImage imageNamed:@"photoUpload_placeholder.png"]];
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
