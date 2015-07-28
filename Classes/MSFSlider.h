//
//  MSFSlider.h
//  MSFSlider
//
//  Created by xbm on 15/7/27.
//  Copyright (c) 2015年 xbm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSFSliderDelegate <NSObject>

- (void)getStringValue:(NSString *)stringvalue;

@end
//typedef void (^ReturnMoneyNum)(NSString *moneyNum);

@interface MSFSlider : UISlider
//@property(nonatomic,copy) ReturnMoneyNum returnMoneyNum;

@property(nonatomic,assign) id<MSFSliderDelegate> delegate;

@end
