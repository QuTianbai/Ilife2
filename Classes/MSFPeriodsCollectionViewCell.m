//
//  MSFPeriodsCollectionViewCell.m
//  MSFPeriodsCollectionView
//
//  Created by xutian on 15/7/27.
//  Copyright (c) 2015年 xutian. All rights reserved.
//

#import "MSFPeriodsCollectionViewCell.h"
#import "UIColor+Utils.h"

@interface MSFPeriodsCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *loacPeriodsLabel;

@end

@implementation MSFPeriodsCollectionViewCell

- (void)awakeFromNib {
	self.layer.borderColor   = [UIColor grayColor].CGColor;
	self.layer.borderWidth   = 1;
	self.layer.cornerRadius  = 7;
	self.layer.masksToBounds = YES;
	
	self.loacPeriodsLabel.backgroundColor = [UIColor clearColor];
	self.loacPeriodsLabel.textColor = [UIColor grayColor];
}

- (void)setText:(NSString *)text {
	_text = text;
	self.loacPeriodsLabel.text = text;
}

- (void)setLocked:(BOOL)locked {
	_locked = locked;
	if (locked) {
		self.userInteractionEnabled = NO;
		self.selected = NO;
		self.layer.borderColor = [UIColor lightGrayColor].CGColor;
		self.loacPeriodsLabel.textColor = [UIColor lightGrayColor];
	} else {
		self.userInteractionEnabled = YES;
		self.layer.borderColor = [UIColor grayColor].CGColor;
		self.loacPeriodsLabel.textColor = [UIColor grayColor];
	}
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (selected) {
		self.layer.borderColor = [UIColor tintColor].CGColor;
		self.loacPeriodsLabel.textColor = [UIColor tintColor];
	} else {
		self.layer.borderColor = [UIColor grayColor].CGColor;
		self.loacPeriodsLabel.textColor = [UIColor grayColor];
	}
}

@end
