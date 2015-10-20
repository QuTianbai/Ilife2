//
//  MSFUserInfoCircleView.m
//  Finance
//
//  Created by 赵勇 on 9/28/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFUserInfoCircleView.h"
#import <Masonry/Masonry.h>
#import <Mantle/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIColor+Utils.h"

@interface MSFUserInfoTitleView : UIView

@property (nonatomic, assign) BOOL highlighted;

/**
 *  按信息类型初始化
 *
 *  @param index 0：基本信息；1：家庭成员信息；2：工作信息
 *
 *  @return 实例
 */
- (instancetype)initWithType:(NSInteger)index;

@end

@implementation MSFUserInfoTitleView

- (instancetype)initWithType:(NSInteger)index {
	self = [super init];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		
		UILabel *label = [[UILabel alloc] init];
		if ([UIScreen mainScreen].bounds.size.width > 320) {
			label.font = [UIFont boldSystemFontOfSize:15];
		} else {
			if ([UIScreen mainScreen].bounds.size.height > 480) {
				label.font = [UIFont boldSystemFontOfSize:13];
			} else {
				label.font = [UIFont boldSystemFontOfSize:11];
			}
		}
		label.textAlignment = NSTextAlignmentCenter;
		label.textColor = [UIColor color999999];
		label.highlightedTextColor = [UIColor whiteColor];
		label.tag = 100;
		[self addSubview:label];
		
		UIImageView *imv = [[UIImageView alloc] init];
		imv.tag = 101;
		[self addSubview:imv];
		
		switch (index) {
			case 0:
				label.text = @"基本信息";
				imv.image = [UIImage imageNamed:@"icon_circle_basic_n.png"];
				imv.highlightedImage = [UIImage imageNamed:@"icon_circle_basic_h.png"];
				break;
			case 1:
				label.text = @"联系人信息";
				imv.image = [UIImage imageNamed:@"icon_circle_home_n.png"];
				imv.highlightedImage = [UIImage imageNamed:@"icon_circle_home_h.png"];
				break;
			case 2:
				label.text = @"职业信息";
				imv.image = [UIImage imageNamed:@"icon_circle_job_n.png"];
				imv.highlightedImage = [UIImage imageNamed:@"icon_circle_job_h.png"];
				break;
		}
		
		@weakify(self)
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			if (index == 2) {
				make.top.equalTo(self);
				make.left.equalTo(self);
				make.right.equalTo(self);
			} else {
				make.bottom.equalTo(self);
				make.left.equalTo(self);
				make.right.equalTo(self);
			}
		}];
		
		[imv mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			if (index == 2) {
				make.bottom.equalTo(self);
				make.centerX.equalTo(self);
				make.width.equalTo(@36);
				make.height.equalTo(@36);
			} else {
				make.top.equalTo(self);
				make.centerX.equalTo(self);
				make.width.equalTo(@36);
				make.height.equalTo(@36);
			}
		}];
	}
	return self;
}

- (void)setHighlighted:(BOOL)highlighted {
	_highlighted = highlighted;
	UILabel *label = (UILabel *)[self viewWithTag:100];
	UIImageView *imv = (UIImageView *)[self viewWithTag:101];
	label.highlighted = highlighted;
	imv.highlighted = highlighted;
}

@end

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
		self.userInteractionEnabled = NO;
		
		UILabel *titleLabel = [[UILabel alloc] init];
		titleLabel.textColor = [UIColor color666666];
		titleLabel.textAlignment = NSTextAlignmentCenter;
		if ([UIScreen mainScreen].bounds.size.height > 480) {
			titleLabel.font = [UIFont boldSystemFontOfSize:15];
		} else {
			titleLabel.font = [UIFont boldSystemFontOfSize:13];
		}
		titleLabel.text = @"资料完整度";
		[self addSubview:titleLabel];
		
		UILabel *percentLabel = [[UILabel alloc] init];
		percentLabel.textColor = [UIColor percentColor];
		percentLabel.textAlignment = NSTextAlignmentCenter;
		if ([UIScreen mainScreen].bounds.size.height > 480) {
			percentLabel.font = [UIFont boldSystemFontOfSize:30];
		} else {
			percentLabel.font = [UIFont boldSystemFontOfSize:25];
		}
		percentLabel.text = @"0%";
		percentLabel.tag = 100;
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
	[super layoutSubviews];
	self.layer.cornerRadius = self.frame.size.width / 2;
}

- (void)setPercent:(NSString *)percent {
	_percent = percent;
	UILabel *label = (UILabel *)[self viewWithTag:100];
	label.text = percent;
}

@end

@interface MSFUserInfoCircleView ()
<UIGestureRecognizerDelegate>

@property (nonatomic, strong) MSFUserInfoCircleInfoView *infoView;
@property (nonatomic, strong) MSFUserInfoTitleView *basicTitle;
@property (nonatomic, strong) MSFUserInfoTitleView *homeTitle;
@property (nonatomic, strong) MSFUserInfoTitleView *jobTitle;

@property (nonatomic, strong) NSString *statusString;
@property (nonatomic, strong) NSArray *statusArray;
@property (nonatomic, assign) NSInteger clickIndex;

@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat centralRate;
@property (nonatomic, assign) CGFloat degree;

@end

@implementation MSFUserInfoCircleView

- (void)dealloc {
	NSLog(@"MSFUserInfoCircleView `-dealloc`");
}

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

- (instancetype)init {
	self = [super init];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	self.backgroundColor = [UIColor whiteColor];
	_margin = 3.0f;
	_centralRate = 0.4f;
	_degree = 0.33f;
	_statusString = @"000";
	
	@weakify(self)
	_clickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			[subscriber sendNext:@(self.clickIndex)];
			[subscriber sendCompleted];
			return nil;
		}];
	}];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
	tap.delegate = self;
	tap.delaysTouchesBegan = YES;
	[self addGestureRecognizer:tap];
	[tap.rac_gestureSignal subscribeNext:^(id x) {
		@strongify(self)
#if DEBUG
		NSLog(@"点击了区域：%ld", (long)self.clickIndex);
#endif
		if (self.onClickBlock) {
			self.onClickBlock(self.clickIndex);
		}
		[self.clickCommand execute:nil];
	}];
	
	_infoView = [[MSFUserInfoCircleInfoView alloc] initWithFrame:CGRectZero];
	[self addSubview:_infoView];
	
	_basicTitle = [[MSFUserInfoTitleView alloc] initWithType:0];
	[self addSubview:_basicTitle];
	
	_homeTitle = [[MSFUserInfoTitleView alloc] initWithType:1];
	[self addSubview:_homeTitle];
	
	_jobTitle = [[MSFUserInfoTitleView alloc] initWithType:2];
	[self addSubview:_jobTitle];
	
	[_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.width.equalTo(self.mas_width).multipliedBy(0.4);
		make.height.equalTo(_infoView.mas_width);
		make.center.equalTo(self);
	}];
	
	[_basicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.centerX.equalTo(self).multipliedBy(1 + _degree * sqrt(3));
		make.centerY.equalTo(self).multipliedBy(1 - _degree);
		make.width.equalTo(@80);
		make.height.equalTo(@50);
	}];
	
	[_homeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.centerX.equalTo(self);
		make.centerY.equalTo(self).multipliedBy(1 + _degree * 2);
		make.width.equalTo(@80);
		make.height.equalTo(@50);
	}];
	
	[_jobTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		@strongify(self)
		make.centerX.equalTo(self).multipliedBy(1 - _degree * sqrt(3));
		make.centerY.equalTo(self).multipliedBy(1 - _degree);
		make.width.equalTo(@80);
		make.height.equalTo(@50);
	}];
	
	[self setCompeltionStatus:@"000"];
}

#pragma mark - TapGesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	CGPoint loc = [gestureRecognizer locationInView:self];
	NSLog(@"---gesture：%f,%f", loc.x, loc.y);
	BOOL shouldTap = [self isEffectiveTap:loc];
	if (shouldTap) {
		_clickIndex = [self tappedArea:loc];
	}
	return shouldTap;
}

- (BOOL)isEffectiveTap:(CGPoint)tapPoint {
	CGFloat x = tapPoint.x - self.frame.size.width / 2;
	CGFloat y = tapPoint.y - self.frame.size.height / 2;
	CGFloat dis = sqrt(x * x + y * y);
	BOOL centerTap = dis < self.frame.size.width * _centralRate * 0.5;
	BOOL outerTap = dis > self.frame.size.width * 0.5;
	return !centerTap && !outerTap;
}

- (NSInteger)tappedArea:(CGPoint)tapPoint {
	if (tapPoint.x > self.frame.size.width / 2) {
		if (tapPoint.y > self.frame.size.height / 2) {
			CGFloat temp = (tapPoint.x - self.frame.size.width / 2) / sqrt(3);
			if (tapPoint.y - self.frame.size.height / 2 > temp) {
				return 1;
			} else {
				return 0;
			}
		} else {
			return 0;
		}
	} else {
		if (tapPoint.y > self.frame.size.height / 2) {
			CGFloat temp = (self.frame.size.width / 2 - tapPoint.x) / sqrt(3);
			if (tapPoint.y - self.frame.size.height / 2 > temp) {
				return 1;
			} else {
				return 2;
			}
		} else {
			return 2;
		}
	}
}

#pragma mark - Layout

- (void)setCompeltionStatus:(NSString *)status {
	if (status.length != 3 || [_statusString isEqualToString:status]) {
		return;
	}
	_statusString = status;
	
	BOOL b0 = [status substringWithRange:NSMakeRange(0, 1)].integerValue == 1;
	BOOL b1 = [status substringWithRange:NSMakeRange(2, 1)].integerValue == 1;
	BOOL b2 = [status substringWithRange:NSMakeRange(1, 1)].integerValue == 1;
	_statusArray = @[@(b0), @(b1), @(b2)];
	
	NSInteger completion = 0;
	if (b0) {
		completion ++;
	}
	if (b1) {
		completion ++;
	}
	if (b2) {
		completion ++;
	}
	
	if (completion == 3) {
		_infoView.percent = @"100%";
	} else {
		_infoView.percent = [NSString stringWithFormat:@"%ld%%", (long)completion * 33];
	}
	
	_basicTitle.highlighted = b0;
	_homeTitle.highlighted  = b1;
	_jobTitle.highlighted   = b2;

	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGFloat midX = rect.size.width / 2;
	CGFloat midY = rect.size.height / 2;
	for (int i = 0; i < 3; i ++) {
		CGPoint center = CGPointZero;
		switch (i) {
			case 0:
				center = CGPointMake(midX + _margin, midY - _margin / sqrt(3));
				break;
			case 1:
				center = CGPointMake(midX, midY + 2 * _margin / sqrt(3));
				break;
			case 2:
				center = CGPointMake(midX - _margin, midY - _margin / sqrt(3));
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
