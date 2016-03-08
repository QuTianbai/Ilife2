//
//	MSFAppliesHeaderView.h
//	Cash
//
//	Created by xbm on 15/5/19.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

__attribute__((deprecated("This class is unavailable")))

@interface MSFAppliesHeaderView : UIView

- (void)createHeaderViewWithPageNum:(NSInteger)pageNum;
- (void)hiddenSubViews;
- (void)showSubviews;

@end
