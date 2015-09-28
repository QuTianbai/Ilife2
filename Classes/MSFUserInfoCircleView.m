//
//  MSFUserInfoCircleView.m
//  Finance
//
//  Created by 赵勇 on 9/28/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFUserInfoCircleView.h"
#import <Masonry/Masonry.h>
#import <libextobjc/extobjc.h>
#import "UIColor+Utils.h"

@interface MSFUserInfoCircleInfoView : UIView

@property (nonatomic, strong) NSString *percent;

@end

@implementation MSFUserInfoCircleInfoView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
		self.layer.cornerRadius = frame.size.width / 2;
		self.clipsToBounds = YES;
		
		UILabel *titleLabel = [[UILabel alloc] init];
		titleLabel.textColor = [UIColor color666666];
		titleLabel.textAlignment = NSTextAlignmentCenter;
		titleLabel.font = [UIFont boldSystemFontOfSize:15];
		titleLabel.text = @"资料完整度";
		[self addSubview:titleLabel];
		
		UILabel *percentLabel = [[UILabel alloc] init];
		percentLabel.textColor = [UIColor percentColor];
		percentLabel.textAlignment = NSTextAlignmentCenter;
		percentLabel.font = [UIFont boldSystemFontOfSize:30];
		percentLabel.text = @"33%";
		[self addSubview:percentLabel];
		
		@weakify(self)
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.left.equalTo(self.mas_left);
			make.right.equalTo(self.mas_right);
			make.centerY.equalTo(self.mas_centerY).offset(-12);
		}];
		
		[percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.left.equalTo(self.mas_left);
			make.right.equalTo(self.mas_right);
			make.top.equalTo(titleLabel.mas_bottom);
		}];
	}
	return self;
}

- (void)layoutSubviews {
	self.layer.cornerRadius = self.frame.size.width / 2;
}

- (void)setPercent:(NSString *)percent {
	_percent = percent;
	
}

@end

@interface MSFUserInfoCircleView ()

@property (nonatomic, strong) MSFUserInfoCircleInfoView *infoView;

@property (nonatomic, strong) NSArray *statusArray;
@property (nonatomic, assign) CGFloat margin;

@end

@implementation MSFUserInfoCircleView

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
	self.backgroundColor = [UIColor whiteColor];
	_margin = 3.0f;
	
	_infoView = [[MSFUserInfoCircleInfoView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[self addSubview:_infoView];
	
	[self setCompeltionStatus:@[@YES, @NO, @YES]];
}

- (void)layoutSubviews {
	CGFloat width = self.frame.size.width * 0.4;
	_infoView.frame = CGRectMake(0, 0, width, width);
	_infoView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

- (void)setCompeltionStatus:(NSArray *)status {
	_statusArray = status;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGFloat midX = rect.size.width / 2;
	CGFloat midY = rect.size.height / 2;
	for (int i = 0; i < 3; i ++) {
		CGPoint center = CGPointZero;
		switch (i) {
			case 0:
				center = CGPointMake(midX + _margin, midY - _margin / sqrt(2));
				break;
			case 1:
				center = CGPointMake(midX, midY + 2 * _margin / sqrt(2));
				break;
			case 2:
				center = CGPointMake(midX - _margin, midY - _margin / sqrt(2));
				break;
		}
		
		UIBezierPath *path = [UIBezierPath
													bezierPathWithArcCenter:center
													radius:(midX - _margin - 5) / 2
													startAngle:- M_PI / 2 + i * M_PI * 2 / 3
													endAngle:M_PI / 6 + i * M_PI * 2 / 3
													clockwise:YES];

		if (_statusArray && [_statusArray[i] boolValue]) {
			[[UIColor completedColor] set];
		} else {
			[[UIColor uncompletedColor] set];
		}
		[path setLineCapStyle:kCGLineCapButt];
		[path setLineWidth:midX - _margin - 5];
		[path stroke];
	}
}

@end
