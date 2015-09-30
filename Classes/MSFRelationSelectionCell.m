//
//  MSFRelationSelectionCell.m
//  Finance
//
//  Created by 赵勇 on 9/30/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFRelationSelectionCell.h"

@interface MSFRelationSelectionCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectionButton;

@end

@implementation MSFRelationSelectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onSelection:(UIButton *)sender {
}

@end
