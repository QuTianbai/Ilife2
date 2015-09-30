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
#import "MSFDeviceGet.h"

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
	_endAngle = - M_PI * 7 / 6;
	_angle = - M_PI * 7 / 6;
	
	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.font = [UIFont boldSystemFontOfSize:14];
	titleLabel.textColor = [UIColor darkCircleColor];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.text = @"可用额度（元）";
	[self addSubview:titleLabel];

	_usableLabel = [[UILabel alloc] init];
	BOOL iphone6 = [UIScreen mainScreen].bounds.size.width > 320;
	_usableLabel.font = [UIFont systemFontOfSize:iphone6 ? 60 : 45];
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
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
	[self addGestureRecognizer:tap];
}

- (void)tap {
	[self setAvailableCredit:@"10000" usedCredit:@"3000"];
}

- (void)setAvailableCredit:(NSString *)ac usedCredit:(NSString *)uc {
	_usableLabel.text = ac;
	_usedLabel.text = [NSString stringWithFormat:@"已用额度￥%@", uc];
	_endAngle = - M_PI * 7 / 6 + ac.floatValue / (ac.floatValue + uc.floatValue) * M_PI * 4 / 3;
	_angle = - M_PI * 7 / 6;
	[self circleAnimation];
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