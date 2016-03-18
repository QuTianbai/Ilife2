//
//  MSFSlider.h
//  MSFSlider
//
//  Created by xbm on 15/7/27.
//  Copyright (c) 2015年 xbm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSFSliderDelegate <NSObject>

@required
- (void)startSliding;
- (void)getStringValue:(NSString *)stringvalue;

@end

@interface MSFSlider : UISlider

@property (nonatomic, strong) UILabel *moneyNumLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) id<MSFSliderDelegate> delegate;
@property (nonatomic, assign) BOOL hiddenAmount;

@end
