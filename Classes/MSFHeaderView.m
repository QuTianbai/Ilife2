//
// MSFHeaderView.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHeaderView.h"
#import "UIColor+Utils.h"

@interface MSFHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView *bar1;
@property (nonatomic, weak) IBOutlet UIImageView *bar2;
@property (weak, nonatomic) IBOutlet UIImageView *bar3;

@property (nonatomic, weak) IBOutlet UIButton *icon1;
@property (nonatomic, weak) IBOutlet UIButton *icon2;
@property (nonatomic, weak) IBOutlet UIButton *icon3;
@property (weak, nonatomic) IBOutlet UIButton *icon4;

@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
@property (nonatomic, weak) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@end

@implementation MSFHeaderView

+ (instancetype)headerViewWithIndex:(NSInteger)index {
	 NSArray *bundles = [[NSBundle mainBundle] loadNibNamed:@"MSFHeaderView" owner:nil options:nil];
	 MSFHeaderView *view = bundles.firstObject;
	 view.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 100);
	 [view updateIndex:index];
	 return view;
}

- (void)updateIndex:(NSInteger)index {
	switch (index) {
		case 0:
			self.icon1.selected = YES;
			self.icon2.selected = NO;
			self.icon3.selected = NO;
			self.icon4.selected = NO;
			self.bar1.highlighted = NO;
			self.bar2.highlighted = NO;
			self.bar3.highlighted = NO;
			self.label1.textColor = [UIColor tintColor];
			self.label2.textColor = [UIColor grayColor];
			self.label3.textColor = [UIColor grayColor];
			self.label4.textColor = [UIColor grayColor];
			break;
		case 1:
			self.icon1.selected = YES;
			self.icon2.selected = YES;
			self.icon3.selected = NO;
			self.icon4.selected = NO;
			self.bar1.highlighted = YES;
			self.bar2.highlighted = NO;
			self.bar3.highlighted = NO;
			self.label1.textColor = [UIColor tintColor];
			self.label2.textColor = [UIColor tintColor];
			self.label3.textColor = [UIColor grayColor];
			self.label4.textColor = [UIColor grayColor];
			break;
		case 2:
			self.icon1.selected = YES;
			self.icon2.selected = YES;
			self.icon3.selected = YES;
			self.icon4.selected = NO;
			self.bar1.highlighted = YES;
			self.bar2.highlighted = YES;
			self.bar3.highlighted = NO;
			self.label1.textColor = [UIColor tintColor];
			self.label2.textColor = [UIColor tintColor];
			self.label3.textColor = [UIColor tintColor];
			self.label4.textColor = [UIColor grayColor];
			break;
		case 3:
			self.icon1.selected = YES;
			self.icon2.selected = YES;
			self.icon3.selected = YES;
			self.icon4.selected = YES;
			self.bar1.highlighted = YES;
			self.bar2.highlighted = YES;
			self.bar3.highlighted = YES;
			self.label1.textColor = [UIColor tintColor];
			self.label2.textColor = [UIColor tintColor];
			self.label3.textColor = [UIColor tintColor];
			self.label4.textColor = [UIColor tintColor];
			break;
		default:
			break;
	}
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, 0, rect.size.height);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
	CGContextSetLineWidth(context, 1);
	[[UIColor borderColor] setStroke];
	CGContextStrokePath(context);
}

@end
