//
//  MSFRelationMarriageCell.m
//  Finance
//
//  Created by 赵勇 on 11/24/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFRelationMarriageCell.h"

@interface MSFRelationMarriageCell ()

@property (weak, nonatomic) IBOutlet UITextField *marriageLabel;

@end

@implementation MSFRelationMarriageCell

- (void)setMarriage:(NSString *)marriage {
	_marriage = marriage;
	_marriageLabel.text = marriage;
}

@end
