//
//  MSFSegment.h
//  Finance
//
//  Created by xbm on 15/7/22.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSFSegmentDelegate <NSObject>

-(void)setLineColor:(NSMutableArray *)array;

@end

@interface MSFSegment : UISegmentedControl

@property(nonatomic,assign)id<MSFSegmentDelegate> delegate;

- (void)setLineColors;
@end
