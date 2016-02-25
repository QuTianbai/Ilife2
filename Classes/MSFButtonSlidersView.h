//
//  MSFButtonSlidersView.h
//  Finance
//
//  Created by xbm on 16/2/23.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSFButtonSlidersDelegate <NSObject>

- (void)didSelectButtonForIndex:(NSInteger)buttonIndex;

@end

@interface MSFButtonSlidersView : UIView

@property (nonatomic, assign) id<MSFButtonSlidersDelegate> delegate;

- (void)buildButtonSliders:(NSArray *)titleArray;

@end
