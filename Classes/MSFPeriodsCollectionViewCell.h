//
//  MSFPeriodsCollectionViewCell.h
//  MSFPeriodsCollectionView
//
//  Created by xutian on 15/7/27.
//  Copyright (c) 2015年 xutian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFPeriodsCollectionViewCell : UICollectionViewCell

// cell显示期数的文本
@property (nonatomic, strong) NSString *text;

// slide滑动时cell处于锁定状态（不可点击颜色变浅）设为YES，否则为NO
@property (nonatomic, assign) BOOL locked;

@end
