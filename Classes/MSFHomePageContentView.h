//
//  MSFHomePageContentView.h
//  Finance
//
//  Created by 赵勇 on 11/28/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//
//  首页马上贷展示页面

#import <UIKit/UIKit.h>

@class RACSignal;

__attribute__((deprecated("This class is unavailable")))

@interface MSFHomePageContentView : UIView

//监听此信号来回去状态按钮的点击事件
@property (nonatomic, strong, readonly) RACSignal *statusSignal;

//传入MSFHomePageCellModel来更新视图
- (void)updateWithModel:(id)model;

@end
