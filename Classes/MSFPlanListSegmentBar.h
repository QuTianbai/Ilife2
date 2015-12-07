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

/*
 * 依靠订阅command来获取点击事件，返回参数为点击的对应标题的index
 */
@property (nonatomic, strong) RACCommand *executeSelectionCommand;

/*
 * 当前选中的按钮编号，可以设置
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/*
 * 出入一组title，作为展示的名称。数目随意，但太多会造成不好点击和文字显示不全
 */
- (instancetype)initWithTitles:(NSArray *)titles;

@end
