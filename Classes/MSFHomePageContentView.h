//
//  MSFHomePageContentView.h
//  Finance
//
//  Created by 赵勇 on 11/28/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface MSFHomePageContentView : UIView

@property (nonatomic, strong, readonly) RACSignal *statusSignal;

- (void)updateWithModel:(id)model;

@end
