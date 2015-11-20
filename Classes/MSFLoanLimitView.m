//
//  MSFLoanLimitView.m
//  Finance
//
//  Created by 赵勇 on 9/28/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFLoanLimitView.h"
#import <Masonry/Masonry.h>
#import <Mantle/EXTScope.h>
#import "UIColor+Utils.h"

@interface MSFLoanLimitView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *usedLabel;
@property (nonatomic, strong) UILabel *usableLabel;

@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat animaAngle;
@property (nonatomic, assign) CGFloat lineWidth;

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
	
	_startAngle = _animaAngle = M_PI_4 * 3;
	
	_titleLabel = [[UILabel alloc] init];
	_titleLabel.textColor = [UIColor darkCircleColor];
	_titleLabel.textAlignment = NSTextAlignmentCenter;
	_titleLabel.text = @"可用额度（元）";
	[self addSubview:_titleLabel];

	_usableLabel = [[UILabel alloc] init];
	_usableLabel.textColor = [UIColor darkCircleColor];
	_usableLabel.textAlignment = NSTextAlignmentCenter;
	[self addSubview:_usableLabel];
	
	_usedLabel = [[UILabel alloc] init];
	_usedLabel.textColor = [UIColor color999999];
	_usedLabel.textAlignment = NSTextAlignmentCenter;
	[self addSubview:_usedLabel];
	
	@weakify(self)
	[_usableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.width.equalTo(self);
		make.centerX.equalTo(self);
		make.centerY.equalTo(self).offset(15);
	}];
	
	[_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.left.equalTo(self).offset(8);
		make.right.equalTo(self).offset(-8);
		make.bottom.equalTo(self.usableLabel.mas_top).offset(-8);
	}];
	
	[_usedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.left.equalTo(self).offset(8);
		make.right.equalTo(self).offset(-8);
		make.bottom.equalTo(self).offset(-5);
	}];
}

- (void)layoutSubviews {
	_lineWidth = self.frame.size.width * 0.05;
	CGFloat f1 = self.frame.size.width * 0.06;
	CGFloat f2 = self.frame.size.width * 0.22;
	CGFloat f3 = self.frame.size.width * 0.05;
	_titleLabel.font  = [UIFont boldSystemFontOfSize:f1];
	_usableLabel.font = [UIFont boldSystemFontOfSize:f2];
	_usedLabel.font   = [UIFont boldSystemFontOfSize:f3];
}

- (void)setAvailableCredit:(NSString *)ac usedCredit:(NSString *)uc {
	if (ac.length == 0 || uc.length == 0) {
		ac = @"0";
		uc = @"0";
		_animaAngle = _startAngle;
	} else {
		_animaAngle = _startAngle + (3 * M_PI - 2 * _startAngle) * ac.floatValue / (ac.floatValue + uc.floatValue);
	}
	_angle = _startAngle;
	_usableLabel.text = ac;
	_usedLabel.text = [NSString stringWithFormat:@"已用额度￥%@", uc];
	[self circleAnimation];
}

- (void)circleAnimation {
	_angle += M_PI / 20;
	if (_angle > _animaAngle) {
		_angle = _animaAngle;
		[self setNeedsDisplay];
		return;
	}
	[self setNeedsDisplay];
	[self performSelector:@selector(circleAnimation)
						 withObject:nil
						 afterDelay:0.02
								inModes:@[NSRunLoopCommonModes]];
}

- (void)drawRect:(CGRect)rect {
	CGFloat expectedRate = sqrtf(2) / 4 + 0.5;
	CGFloat rate = (rect.size.height - 2 * _lineWidth) / (rect.size.width - 2 * _lineWidth);
	CGFloat radius;
	if (rate > expectedRate) {
		radius = (rect.size.width - _lineWidth * 2) / 2;
	} else {
		radius = (rect.size.height - _lineWidth * 2) / (1 + sin(M_PI - _startAngle));
	}
	CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height - sin(M_PI - _startAngle) * radius - _lineWidth / 2);
	UIBezierPath *path1 = [UIBezierPath
												bezierPathWithArcCenter:center
												radius:radius
												startAngle:_startAngle
												endAngle:M_PI - _startAngle
												clockwise:YES];
	[path1 setLineCapStyle:kCGLineCapRound];
	[path1 setLineWidth:_lineWidth];
	[[UIColor lightCircleColor] set];
	[path1 stroke];
	
	UIBezierPath *path2 = [UIBezierPath
												bezierPathWithArcCenter:center
												radius:radius
												startAngle:_startAngle
												endAngle:_angle
												clockwise:YES];
	[path2 setLineCapStyle:kCGLineCapRound];
	[path2 setLineWidth:_lineWidth];
	[[UIColor darkCircleColor] set];
	[path2 stroke];
}

@end
