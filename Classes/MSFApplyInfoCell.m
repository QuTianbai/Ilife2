//
//  MSFApplyInfoCell.m
//  Finance
//
//  Created by 赵勇 on 12/3/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFApplyInfoCell.h"

@implementation MSFApplyInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
		self.selectionStyle  = UITableViewCellSelectionStyleNone;
		self.type = MSFCellTypeUnknown;
	}
	return self;
}

- (void)setType:(MSFApplyInfoCellType)type {
	if (type == _type) {
		return;
	}
	_type = type;
	if (type == MSFCellTypeUnknown) {
		return;
	}
	[self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[obj removeFromSuperview];
	}];
	switch (type) {
		case MSFCellTypeContent:
			[self contentCell];
			break;
		case MSFCellTypeSelection:
			[self selectionCell];
			break;
		case MSFCellTypeCodePhone:
			[self codePhoneCell];
			break;
		case MSFCellTypeCodePhoneExt:
			[self codePhoneExtCell];
			break;
		case MSFCellTypePhoneSelection:
			[self phoneSelectionCell];
			break;
		case MSFCellTypeSwitch:
			[self switchCell];
			break;
		case MSFCellTypeAddContact:
			[self addContactCell];
			break;
		case MSFCellTypeConfirm:
			[self confirmCell];
			break;
		case MSFCellTypeBoldTitle:
			[self boldTitleCell];
			break;
		case MSFCellTypeContentUnit:
			[self contentUnitCell];
			break;
		case MSFCellTypeEduLength:
			[self eduLengthCell];
			break;
		default: break;
	}
}

- (void)contentCell {
	
}

- (void)selectionCell {
	
}

- (void)codePhoneCell {
	
}

- (void)codePhoneExtCell {
	
}

- (void)phoneSelectionCell {
	
}

- (void)switchCell {
	
}

- (void)addContactCell {
	
}

- (void)confirmCell {
	
}

- (void)boldTitleCell {
	
}

- (void)contentUnitCell {
	
}

- (void)eduLengthCell {
	
}

@end
