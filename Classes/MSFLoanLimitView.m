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
#import "MSFDeviceGet.h"

@interface MSFLoanLimitView ()

@property (nonatomic, strong) UILabel *usedLabel;
@property (nonatomic, strong) UILabel *usableLabel;

@property (nonatomic, assign) CGFloat standardFontSize;
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
	_standardFontSize = [UIScreen mainScreen].bounds.size.width > 320 ? 60 : 45;
	_lineWidth = 11.0f;
	_endAngle = - M_PI * 7 / 6;
	_angle = - M_PI * 7 / 6;
	
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.font = [UIFont boldSystemFontOfSize:14];
	titleLabel.textColor = [UIColor darkCircleColor];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.text = @"可用额度（元）";
	[self addSubview:titleLabel];

	_usableLabel = [[UILabel alloc] init];
	_usableLabel.font = [UIFont systemFontOfSize:_standardFontSize];
	_usableLabel.textColor = [UIColor darkCircleColor];
	_usableLabel.textAlignment = NSTextAlignmentCenter;
	_usableLabel.text = @"8000";
	[self addSubview:_usableLabel];
	
	_usedLabel = [[UILabel alloc] init];
	_usedLabel.font = [UIFont boldSystemFontOfSize:12];
	_usedLabel.textColor = [UIColor color999999];
	_usedLabel.textAlignment = NSTextAlignmentCenter;
	_usedLabel.text = @"已用额度￥2000";
	[self addSubview:_usedLabel];
	
	@weakify(self)
	[_usableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.width.equalTo(self.mas_height).multipliedBy(1.1);
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
	_angle = - M_PI * 7 / 6;
	if (ac.length == 0 || uc.length == 0) {
		ac = @"0";
		uc = @"0";
		_endAngle = _angle;
	} else {
		_endAngle = - M_PI * 7 / 6 + ac.floatValue / (ac.floatValue + uc.floatValue) * M_PI * 4 / 3;
	}
	[self ajustLabelFont:ac];
	_usableLabel.text = ac;
	_usedLabel.text = [NSString stringWithFormat:@"已用额度￥%@", uc];
	[self circleAnimation];
}

- (void)ajustLabelFont:(NSString *)ac {
	CGFloat width = [ac boundingRectWithSize:CGSizeMake(10000, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:_standardFontSize]} context:nil].size.width;
	CGFloat fontSize = 0;
	if (width > self.frame.size.height * 1.1) {
		fontSize = floor(_standardFontSize * self.frame.size.height * 1.1 / width);
	} else {
		fontSize = _standardFontSize;
	}
	_usableLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)circleAnimation {
	_angle += M_PI / 30;
	if (_angle > _endAngle) {
		_angle = _endAngle;
		[self setNeedsDisplay];
		return;
	}
	[self setNeedsDisplay];
	[self performSelector:@selector(circleAnimation) withObject:nil afterDelay:0.02 inModes:@[NSRunLoopCommonModes]];
}

- (CGFloat)setAngle {
	return 0;
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
	[[UIColor lightCircleColor] set];
	[path1 stroke];
	
	UIBezierPath *path2 = [UIBezierPath
												bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, radius + _lineWidth)
												radius:radius
												startAngle:- M_PI * 7 / 6
												endAngle:_angle
												clockwise:YES];
	[path2 setLineCapStyle:kCGLineCapRound];
	[path2 setLineWidth:_lineWidth];
	[[UIColor darkCircleColor] set];
	[path2 stroke];
}

@end
