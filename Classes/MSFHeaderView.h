//
// MSFHeaderView.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFHeaderView : UIView

- (void)updateIndex:(NSInteger)index;

+ (instancetype)headerViewWithIndex:(NSInteger)index;

@end
