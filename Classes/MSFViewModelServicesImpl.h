//
// MSFViewModelServicesImpl.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MSFViewModelServices.h"

@interface MSFViewModelServicesImpl : NSObject <MSFViewModelServices>

- (instancetype)initWithTabBarController:(UITabBarController *)tabBarController;

@end
