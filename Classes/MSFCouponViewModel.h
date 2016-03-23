//
// MSFCouponViewModel.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface MSFCouponViewModel : RVMViewModel

// 标题
@property (nonatomic, strong, readonly) NSString *title;

// 副标题
@property (nonatomic, strong, readonly) NSString *subtitle;

// 面值
@property (nonatomic, strong, readonly) NSString *value;

// 介绍`面值下面的描述`
@property (nonatomic, strong, readonly) NSString *intro;

// 使用时间段
@property (nonatomic, strong, readonly) NSString *timeRange;

// 剩余时间 `2天后到期`
@property (nonatomic, strong, readonly) NSString *timeLeft;

// 小于7天的优惠券给予到期时间提示
@property (nonatomic, assign, readonly) BOOL isWarning;

// 截止时间天数
@property (nonatomic, assign, readonly) NSInteger days;

// icon的名字
@property (nonatomic, strong, readonly) NSString *imageName;

// 状态值
@property (nonatomic, strong, readonly) NSString *status;

// 剩余时间背景
@property (nonatomic, strong, readonly) NSString *deadlineImageName;

- (instancetype)initWithModel:(id)model;

@end
