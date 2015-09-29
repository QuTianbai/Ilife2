//
//  MSFUserInfoCircleView.h
//  Finance
//
//  Created by 赵勇 on 9/28/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFUserInfoCircleView : UIView

@property (nonatomic, copy) void (^onClickBlock) (NSInteger index);

- (void)setCompeltionStatus:(NSArray *)status;

@end
