//
//  MSFRelationSwitchCell.m
//  Finance
//
//  Created by 赵勇 on 9/30/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFRelationSwitchCell.h"

@interface MSFRelationSwitchCell ()
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation MSFRelationSwitchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
