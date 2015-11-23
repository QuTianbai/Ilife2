//
//  MSFApplyView.h
//  Finance
//
//  Created by 赵勇 on 11/20/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSFApplyViewType) {
	MSFApplyViewTypeMS,
	MSFApplyViewTypeLimitMS,
	MSFApplyViewTypeML,
	MSFApplyViewTypeMSFull
};

@interface MSFApplyView : UIView

- (instancetype)initWithStatus:(MSFApplyViewType)type
									 actionBlock:(void(^)())action;

@end
