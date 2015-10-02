//
//  MSFTeam.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFTeam.h"

@implementation MSFTeam

#pragma mark - MSFSelectionItem

- (NSString *)title {
	return [self.loanTeam stringByAppendingString:@"个月"];
}

- (NSString *)subtitle {
	return @"";
}

@end
