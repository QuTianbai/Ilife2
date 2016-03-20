//
//  MSFSelectProductViewController.h
//  Finance
//
//  Created by 胥佰淼 on 16/3/19.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFViewModelServices.h"

typedef void(^ReturnSelectTabBar)(NSString *str);

@interface MSFSelectProductViewController : UIViewController

@property (nonatomic, copy) ReturnSelectTabBar returnSelectTabBatBlock;

- (void)returnBabBarWithBlock:(ReturnSelectTabBar)block;

- (instancetype)initWithServices:(id)services;

@end
