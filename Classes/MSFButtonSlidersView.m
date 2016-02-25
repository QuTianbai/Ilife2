//
//  MSFButtonSlidersView.m
//  Finance
//
//  Created by xbm on 16/2/23.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFButtonSlidersView.h"
#import "UIColor+Utils.h"

@interface MSFButtonSlidersView ()

@property (nonatomic, strong) UIView *lineBottomView;\
@property (nonatomic, strong) UIButton *oldButton;

@end

@implementation MSFButtonSlidersView

- (void)buildButtonSliders:(NSArray *)titleArray {
	CGFloat screenWidth = self.frame.size.width;
	CGFloat screenHeight = self.frame.size.height;
	CGFloat lineBottomHeight = 1;
	for (int i = 0; i < titleArray.count; i++) {
		UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth / titleArray.count * i, 0, screenWidth / titleArray.count - 1, screenHeight - lineBottomHeight)];
		button.backgroundColor = [UIColor whiteColor];
		if (i == 0) {
			button.selected = YES;
			self.oldButton = button;
		}
		button.tag = 1000 + i;
		NSLog(@"%@", titleArray[i]);
		[button setTitle:titleArray[i] forState:UIControlStateNormal];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button setTitleColor:[UIColor navigationBgColor] forState:UIControlStateSelected];
		button.titleLabel.font = [UIFont systemFontOfSize:15];
		[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];

	}
	self.lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - lineBottomHeight, screenWidth / titleArray.count, lineBottomHeight)];
	self.lineBottomView.backgroundColor = [UIColor navigationBgColor];
	[self addSubview:self.lineBottomView];
}

- (void)buttonClicked:(UIButton *)sender {
	self.oldButton.selected = NO;
	sender.selected = YES;
	self.oldButton = sender;
	[UIView animateWithDuration:.3 animations:^{
		CGPoint center = self.lineBottomView.center;
		center.x = sender.center.x;
		self.lineBottomView.center = center;
	}];
	if ([self.delegate respondsToSelector:@selector(didSelectButtonForIndex:)]) {
		[self.delegate didSelectButtonForIndex:sender.tag];
	}
}

@end
