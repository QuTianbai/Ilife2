//
// MSFHeaderView.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHeaderView.h"
#import "UIColor+Utils.h"
#define COLOR_HAS_COMPLETE  [UIColor colorWithRed:121/255.0f green:201/255.0f blue:255/255.0f alpha:1]
#define COLOR_NOT_COMPLETE  [UIColor blackColor]

#define COLOR_CURRENT_STEP  [UIColor colorWithRed:61/255.0f green:165/255.0f blue:248/255.0f alpha:1]

@interface MSFHeaderView ()

@property (nonatomic, weak) IBOutlet UIImageView *bar0;
@property (nonatomic, weak) IBOutlet UIImageView *bar1;
@property (nonatomic, weak) IBOutlet UIImageView *bar2;
@property (weak, nonatomic) IBOutlet UIImageView *bar3;
@property (weak, nonatomic) IBOutlet UIImageView *bar4;


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
	 view.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 88);
	 [view updateIndex:index];
		view.bar1.image = [[UIImage imageNamed:@"bar-normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 5, 2, 5) resizingMode:UIImageResizingModeTile];
		view.bar1.highlightedImage = [[UIImage imageNamed:@"bar-highlighted.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11, 0, 11) resizingMode:UIImageResizingModeTile];
		view.bar2.image = [[UIImage imageNamed:@"bar-normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11, 0, 11) resizingMode:UIImageResizingModeTile];
		view.bar2.highlightedImage = [[UIImage imageNamed:@"bar-highlighted.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11, 0, 11) resizingMode:UIImageResizingModeTile];
        view.bar0.image = [[UIImage imageNamed:@"bar-normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 5, 2, 5) resizingMode:UIImageResizingModeTile];
        view.bar0.highlightedImage = [[UIImage imageNamed:@"bar-highlighted.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11, 0, 11) resizingMode:UIImageResizingModeTile];
        view.bar3.image = [[UIImage imageNamed:@"bar-normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11, 0, 11) resizingMode:UIImageResizingModeTile];
        view.bar3.highlightedImage = [[UIImage imageNamed:@"bar-highlighted.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11, 0, 11) resizingMode:UIImageResizingModeTile];
        view.bar4.image = [[UIImage imageNamed:@"bar-normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11, 0, 11) resizingMode:UIImageResizingModeTile];
        view.bar4.highlightedImage = [[UIImage imageNamed:@"bar-highlighted.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11, 0, 11) resizingMode:UIImageResizingModeTile];
	
	 return view;
}

- (void)updateIndex:(NSInteger)index {
	switch (index) {
		case 0:
			self.icon1.selected = YES;
			self.icon2.selected = NO;
			self.icon3.selected = NO;
			self.icon4.selected = NO;
            self.bar0.highlighted = YES;
			self.bar1.highlighted = NO;
			self.bar2.highlighted = NO;
			self.bar3.highlighted = NO;
            self.bar4.highlighted = NO;
			self.label1.textColor = COLOR_CURRENT_STEP;
			self.label2.textColor = COLOR_NOT_COMPLETE;
			self.label3.textColor = COLOR_NOT_COMPLETE;
			self.label4.textColor = COLOR_NOT_COMPLETE;
			break;
		case 1:
			self.icon1.selected = YES;
			self.icon2.selected = YES;
			self.icon3.selected = NO;
			self.icon4.selected = NO;
            self.bar0.highlighted = YES;
			self.bar1.highlighted = YES;
			self.bar2.highlighted = NO;
			self.bar3.highlighted = NO;
            self.bar4.highlighted = NO;
			self.label1.textColor = COLOR_HAS_COMPLETE;
			self.label2.textColor = COLOR_CURRENT_STEP;
			self.label3.textColor = COLOR_NOT_COMPLETE;
			self.label4.textColor = COLOR_NOT_COMPLETE;
			break;
		case 2:
			self.icon1.selected = YES;
			self.icon2.selected = YES;
			self.icon3.selected = YES;
			self.icon4.selected = NO;
            self.bar0.highlighted = YES;
			self.bar1.highlighted = YES;
			self.bar2.highlighted = YES;
			self.bar3.highlighted = NO;
            self.bar4.highlighted = NO;
			self.label1.textColor = COLOR_HAS_COMPLETE;
			self.label2.textColor = COLOR_HAS_COMPLETE;
			self.label3.textColor = COLOR_CURRENT_STEP;
			self.label4.textColor = COLOR_NOT_COMPLETE;
			break;
		case 3:
			self.icon1.selected = YES;
			self.icon2.selected = YES;
			self.icon3.selected = YES;
			self.icon4.selected = YES;
            self.bar0.highlighted = YES;
			self.bar1.highlighted = YES;
			self.bar2.highlighted = YES;
			self.bar3.highlighted = YES;
            self.bar4.highlighted = NO;
			self.label1.textColor = COLOR_HAS_COMPLETE;
			self.label2.textColor = COLOR_HAS_COMPLETE;
			self.label3.textColor = COLOR_HAS_COMPLETE;
            self.label4.textColor = COLOR_CURRENT_STEP;
			break;
		default:
			break;
	}
}

@end
