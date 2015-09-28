//
//  MSFLoanLimitView.m
//  Finance
//
//  Created by 赵勇 on 9/28/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFLoanLimitView.h"
#import <Masonry/Masonry.h>
#import <libextobjc/extobjc.h>
#import "UIColor+Utils.h"

@interface MSFLoanLimitView ()

@property (nonatomic, strong) UILabel *usedLabel;
@property (nonatomic, strong) UILabel *usableLabel;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) CGFloat angle;

@end

@implementation MSFLoanLimitView

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
	_lineWidth = 11.0f;
	_endAngle = 0;
	
	
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.font = [UIFont boldSystemFontOfSize:14];
	titleLabel.textColor = [UIColor themeColorNew];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.text = @"可用额度（元）";
	[self addSubview:titleLabel];

	_usableLabel = [[UILabel alloc] init];
	_usableLabel.font = [UIFont systemFontOfSize:60];
	_usableLabel.textColor = [UIColor themeColorNew];
	_usableLabel.textAlignment = NSTextAlignmentCenter;
	_usableLabel.text = @"8000";
	[self addSubview:_usableLabel];
	
	_usedLabel = [[UILabel alloc] init];
	_usedLabel.font = [UIFont boldSystemFontOfSize:12];
	_usedLabel.textColor = [UIColor lightGrayColor];
	_usedLabel.textAlignment = NSTextAlignmentCenter;
	_usedLabel.text = @"已用额度￥2000";
	[self addSubview:_usedLabel];
	
	@weakify(self)
	[_usableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.left.equalTo(self.mas_left).offset(8);
		make.right.equalTo(self.mas_right).offset(-8);
		make.centerX.equalTo(self.mas_centerX);
		make.centerY.equalTo(self.mas_centerY).offset(15);
	}];
	
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.left.equalTo(self.mas_left).offset(8);
		make.right.equalTo(self.mas_right).offset(-8);
		make.bottom.equalTo(self.usableLabel.mas_top).offset(-8);
	}];
	
	[_usedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.left.equalTo(self.mas_left).offset(8);
		make.right.equalTo(self.mas_right).offset(-8);
		make.bottom.equalTo(self.mas_bottom).offset(-5);
	}];
}

- (void)setAvailableCredit:(NSString *)ac usedCredit:(NSString *)uc {
	_usableLabel.text = ac;
	_usedLabel.text = [NSString stringWithFormat:@"已用额度￥%@", uc];
	
}

- (void)circleAnimation {
	
	[self performSelector:@selector(circleAnimation) withObject:nil afterDelay:0.02 inModes:@[NSRunLoopCommonModes]];
}

- (CGFloat)endAngle {
	
}

- (void)drawRect:(CGRect)rect {
	CGFloat radius = (rect.size.height - _lineWidth * 2) * 2 / 3;
	
	UIBezierPath *path1 = [UIBezierPath
												bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, radius + _lineWidth)
												radius:radius
												startAngle:M_PI * 5 / 6
												endAngle:M_PI / 6
												clockwise:YES];
	[path1 setLineCapStyle:kCGLineCapRound];
	[path1 setLineWidth:_lineWidth];
	[[UIColor lightThemeColor] set];
	[path1 stroke];
	
	UIBezierPath *path2 = [UIBezierPath
												bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, radius + _lineWidth)
												radius:radius
												startAngle:M_PI * 5 / 6
												endAngle:M_PI * 9 / 6
												clockwise:YES];
	[path2 setLineCapStyle:kCGLineCapRound];
	[path2 setLineWidth:_lineWidth];
	[[UIColor themeColorNew] set];
	[path2 stroke];
}

@end
