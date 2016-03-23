//
//  MSFPlanListSegmentBar.m
//  Finance
//
//  Created by 赵勇 on 11/17/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFPlanListSegmentBar.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIColor+Utils.h"

@interface MSFPlanListSegmentBar ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *bar;
@property (nonatomic, assign) BOOL locked;

@end

@implementation MSFPlanListSegmentBar

- (instancetype)initWithTitles:(NSArray *)titles {
	self = [super init];
	if (self) {
		for (int i = 0; i < titles.count; i++) {
			NSAssert([titles[i] isKindOfClass:NSString.class], @"'MSFPlanListSegmentBar' error : Title is not a string!");
		}
		self.backgroundColor = UIColor.whiteColor;
		_titles = titles;
		_selectedIndex = 0;
		
		_bar = [[UIView alloc] init];
		_bar.backgroundColor = UIColor.themeColorNew;
		[self addSubview:_bar];
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
		tap.delegate = self;
		tap.delaysTouchesBegan = YES;
		[self addGestureRecognizer:tap];
		
		_executeSelectionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			return [RACSignal return:input];
		}];
				
	}
	return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
	_selectedIndex = selectedIndex;
	[self setNeedsDisplay];
	[self barAnimation];
}

- (void)layoutSubviews {
	if (_titles.count > 0) {
		CGFloat width = self.frame.size.width / _titles.count;
		_bar.frame = CGRectMake(width * _selectedIndex, self.frame.size.height - 4, width, 4);
	}
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	if (_locked) {
		return NO;
	}
	CGPoint loc = [gestureRecognizer locationInView:self];
	int index = -1;
	CGFloat width = self.frame.size.width / _titles.count;
	for (int i = 0; i < _titles.count; i++) {
		if (CGRectContainsPoint(CGRectMake(width * i, 0, width, self.frame.size.height), loc)) {
			index = i;
			break;
		}
	}
	if (index > -1 && (_selectedIndex != index || _titles.count == 1)) {
		_selectedIndex = index;
		[self setNeedsDisplay];
		[self barAnimation];
		return YES;
	} else {
		return NO;
	}
}

- (void)barAnimation {
	_locked = YES;
	[_executeSelectionCommand execute:@(_selectedIndex)];
	CGFloat width = self.frame.size.width / _titles.count;
	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		_bar.frame = CGRectMake(width * _selectedIndex, self.frame.size.height - 4, width, 4);
	} completion:^(BOOL finished) {
		_locked = NO;
	}];
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	if (_titles.count == 0) {
		return;
	}
	CGFloat width = rect.size.width / _titles.count;
	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.lineBreakMode = NSLineBreakByTruncatingTail;
	style.alignment = NSTextAlignmentCenter;
	UIFont *font = [UIFont systemFontOfSize:15];
	NSMutableDictionary *attri = [NSMutableDictionary dictionaryWithDictionary:
	@{NSForegroundColorAttributeName : UIColor.themeColorNew,
		NSFontAttributeName : font,
		NSParagraphStyleAttributeName : style}];
	for (int i = 0; i < _titles.count; i++) {
		if (i == _selectedIndex) {
			[attri setObject:UIColor.themeColorNew
								forKey:NSForegroundColorAttributeName];
		} else {
			[attri setObject:UIColor.lightGrayColor
								forKey:NSForegroundColorAttributeName];
		}
		[_titles[i] drawInRect:CGRectMake(width * i, (rect.size.height - font.lineHeight) / 2, width, rect.size.height)
						withAttributes:attri];
	}
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, 0, rect.size.height);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
	CGContextSetLineWidth(context, 1);
	CGContextSetStrokeColorWithColor(context, UIColor.borderColor.CGColor);
	CGContextStrokePath(context);
}

@end
