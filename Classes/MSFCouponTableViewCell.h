//
// MSFCouponTableViewCell.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@interface MSFCouponTableViewCell : UITableViewCell <MSFReactiveView>

// 标题
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

// 副标题
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;

// 面值
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

// 介绍`面值下面的描述`
@property (nonatomic, weak) IBOutlet UILabel *introLabel;

// 使用时间段
@property (nonatomic, weak) IBOutlet UILabel *timeRangeLabel;

// 剩余时间 `2天后到期`
@property (nonatomic, weak) IBOutlet UILabel *timeLeftLabel;

@property (nonatomic, weak) IBOutlet UIImageView *statusView;

@end
