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
//点击事件RACCommand
@property (nonatomic, strong) RACCommand *clickCommand;

- (void)setCompeltionStatus:(NSArray *)status;

@end
