//
//  MSFInputTradePasswordViewController.h
//  Finance
//
//  Created by xbm on 15/9/30.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSFInputTradePasswordDelegate <NSObject>

- (void)getTradePassword:(NSString *)pwd type:(int)type;

@optional
- (void)cancel;

@end

@interface MSFInputTradePasswordViewController : UIViewController

@property (nonatomic, assign) id<MSFInputTradePasswordDelegate> delegate;

@property (nonatomic, assign) int type;

@end
