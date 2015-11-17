//
//  MSFPlanListSegmentBar.h
//  Finance
//
//  Created by 赵勇 on 11/17/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACCommand;

@interface MSFPlanListSegmentBar : UIView

- (instancetype)initWithTitles:(NSArray *)titles;

@property (nonatomic, strong) RACCommand *executeSelectionCommand;

@end
