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

@property (nonatomic, weak) IBOutlet UIButton *icon1;
@property (nonatomic, weak) IBOutlet UIButton *icon2;
@property (nonatomic, weak) IBOutlet UIButton *icon3;

@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
@property (nonatomic, weak) IBOutlet UILabel *label3;

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
			self.bar1.highlighted = NO;
			self.bar2.highlighted = NO;
			self.label1.textColor = [UIColor tintColor];
			self.label2.textColor = [UIColor grayColor];
			self.label3.textColor = [UIColor grayColor];
			break;
		case 1:
			self.icon1.selected = YES;
			self.icon2.selected = YES;
			self.icon3.selected = NO;
			self.bar1.highlighted = YES;
			self.bar2.highlighted = NO;
			self.label1.textColor = [UIColor tintColor];
			self.label2.textColor = [UIColor tintColor];
			self.label3.textColor = [UIColor grayColor];
			break;
		case 2:
			self.icon1.selected = YES;
			self.icon2.selected = YES;
			self.icon3.selected = YES;
			self.bar1.highlighted = YES;
			self.bar2.highlighted = YES;
			self.label1.textColor = [UIColor tintColor];
			self.label2.textColor = [UIColor tintColor];
			self.label3.textColor = [UIColor tintColor];
			break;
		default:
			break;
	}
}

@end
