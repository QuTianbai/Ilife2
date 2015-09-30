//
//  MSFRelationTFCell.m
//  Finance
//
//  Created by 赵勇 on 9/30/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFRelationTFCell.h"

@interface MSFRelationTFCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *tfInput;

@end

@implementation MSFRelationTFCell

- (void)setTitle:(NSString *)title placeholder:(NSString *)ph {
	_titleLabel.text = title;
	_tfInput.placeholder = ph;
}

@end
