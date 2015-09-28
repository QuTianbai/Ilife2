//
//  MSFloanLimitView.m
//  Finance
//
//  Created by 赵勇 on 9/28/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFloanLimitView.h"
#import <Masonry/Masonry.h>
#import <libextobjc/extobjc.h>
#import "UIColor+Utils.h"

@interface MSFloanLimitView ()

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UILabel *usedLabel;
@property (nonatomic, strong) UILabel *usableLabel;

@end

@implementation MSFloanLimitView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	_lineWidth = 8.0f;
	
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.font = [UIFont boldSystemFontOfSize:16];
	titleLabel.textColor = [UIColor themeColorNew];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	[self addSubview:titleLabel];
	@weakify(self)
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.left.equalTo(self.mas_left).offset(8);
		make.right.equalTo(self.mas_right).offset(-8);
		make.top.equalTo(self.mas_top).offset(8);
	}];
	
	_usableLabel = [[UILabel alloc] init];
	_usableLabel.font = [UIFont boldSystemFontOfSize:25];
	_usableLabel.textColor = [UIColor themeColorNew];
	_usableLabel.textAlignment = NSTextAlignmentCenter;
	[self addSubview:_usableLabel];
	
	[_usableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.left.equalTo(self.mas_left).offset(8);
		make.right.equalTo(self.mas_right).offset(-8);
		make.centerX.equalTo(self.mas_centerX);
		make.centerY.equalTo(self.mas_centerY);
	}];
	
	_usedLabel = [[UILabel alloc] init];
	_usedLabel.font = [UIFont boldSystemFontOfSize:12];
	_usedLabel.textColor = [UIColor borderColor];
	_usedLabel.textAlignment = NSTextAlignmentCenter;
	[self addSubview:_usedLabel];
	
	[_usedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.left.equalTo(self.mas_left).offset(8);
		make.right.equalTo(self.mas_right).offset(-8);
		make.centerX.equalTo(self.mas_centerX);
		make.centerY.equalTo(self.mas_centerY);
	}];
}

- (void)drawRect:(CGRect)rect {
	CGFloat radius = (rect.size.height - _lineWidth * 2) * 2 / 3;
	
	UIBezierPath *path1 = [UIBezierPath
												bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, radius + _lineWidth)
												radius:radius
												startAngle:- M_PI * 7 / 6
												endAngle:M_PI / 6
												clockwise:YES];
	[path1 setLineCapStyle:kCGLineCapRound];
	[path1 setLineWidth:_lineWidth];
	[[UIColor lightThemeColor] set];
	[path1 stroke];
	
	UIBezierPath *path2 = [UIBezierPath
												bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, radius + _lineWidth)
												radius:radius
												startAngle:M_PI * (- 7 / 6)
												endAngle:0
												clockwise:YES];
	[path2 setLineCapStyle:kCGLineCapRound];
	[path2 setLineWidth:_lineWidth];
	[[UIColor themeColorNew] set];
	[path2 stroke];
}

@end
