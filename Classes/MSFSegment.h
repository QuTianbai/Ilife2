//
//  MSFSegment.h
//  Finance
//
//  Created by xbm on 15/7/22.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

__attribute__((deprecated("This class is unavailable")))

@protocol MSFSegmentDelegate <NSObject>

- (void)setLineColor:(NSMutableArray *)array;

@end

__attribute__((deprecated("This class is unavailable")))

@interface MSFSegment : UISegmentedControl

@property (nonatomic, assign) id <MSFSegmentDelegate> delegate;

- (void)setLineColors;

@end
