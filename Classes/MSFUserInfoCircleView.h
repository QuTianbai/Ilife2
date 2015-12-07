//
//  MSFUserInfoCircleView.h
//  Finance
//
//  Created by 赵勇 on 9/28/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACCommand;

@interface MSFUserInfoCircleView : UIView

//点击事件Block
@property (nonatomic, copy) void (^onClickBlock) (NSInteger index);
//点击事件RACCommand，与Block任选其一使用即可
@property (nonatomic, strong) RACCommand *clickCommand;
//标记是否显示，只是一个标记值，并不改变view;
@property (nonatomic, assign) BOOL show;

- (void)setCompeltionStatus:(NSString *)status;

@end
