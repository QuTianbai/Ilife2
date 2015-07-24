//
//	MSFAppliesHeaderView.m
//	Cash
//
//	Created by xbm on 15/5/19.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFAppliesHeaderView.h"
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"

@implementation MSFAppliesHeaderView

- (id)init {
	if (self = [super init]) {
		self.backgroundColor = [MSFCommandView getColorWithString:BOTTOMCOLOR];
		[self createHeaderViewWithPageNum:3];
	}
	
	return self;
}

//-(id)initWithFrame:(CGRect)frame
//{
//	if (self=[super initWithFrame:frame]) {
//		//self.frame=frame;
//		self.backgroundColor=[MSFCommandView getColorWithString:BOTTOMCOLOR];
//	}
//	
//	return self;
//}
- (void)createHeaderViewWithPageNum:(NSInteger)pageNum {
	NSArray *titleArray = @[@"收入信息", @"个人信息", @"家庭信息", @"提交申请"];
	for (int i = 0;i<titleArray.count;i++) {
		NSString *title = titleArray[i];
		UILabel *label = [MSFCommandView createLabelWithTitle:title backgroundColor:[UIColor clearColor] titleColor:[MSFCommandView getColorWithString:POINTCOLOR] frame:CGRectMake(SCREENWIDTH / 4 * i, 10, SCREENWIDTH / 4, 30) tag:1000 + i];
		
		
		
		UILabel *circleLabel = [MSFCommandView createLabelWithTitle:@"" backgroundColor:[UIColor clearColor] titleColor:nil frame:CGRectMake(SCREENWIDTH / 4 * i + (SCREENWIDTH / 8) - 10, 40, 12, 12) tag:2000 + i];
		
		circleLabel.layer.cornerRadius = 6;
		if (i<pageNum) {
			circleLabel.layer.borderWidth = 6;
		} else {
			circleLabel.layer.borderWidth = 1;
		}
		
		circleLabel.layer.borderColor = [MSFCommandView getColorWithString:POINTCOLOR].CGColor;
		
		
		if (i < titleArray.count - 1) {
			UILabel *lineLabel = [MSFCommandView createLabelWithTitle:@"" backgroundColor:[MSFCommandView getColorWithString:POINTCOLOR] titleColor:nil frame:CGRectMake(circleLabel.frame.origin.x + circleLabel.frame.size.width, circleLabel.frame.origin.y + circleLabel.frame.size.height / 2 - 1, SCREENWIDTH / 4 - 12, 2) tag:3000];
			
			[self addSubview:lineLabel];
		}
		
		[self addSubview:label];
		[self addSubview:circleLabel];
	}
}

- (void)hiddenSubViews {
	for (UIView *view in [self subviews]) {
		view.hidden = YES;
	}
}

- (void)showSubviews {
	for (UIView *view in self.subviews) {
		view.hidden = NO;
	}
}

@end
