//
//  MSFSelectProductViewController.m
//  Finance
//
//  Created by 胥佰淼 on 16/3/19.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFSelectProductViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFTabBarController.h"
#import "MSFUser.h"
#import "MSFClient.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFSelectProductViewController ()
@property (weak, nonatomic) IBOutlet UIButton *jumpBT;
@property (weak, nonatomic) IBOutlet UIButton *socialBT;
@property (weak, nonatomic) IBOutlet UIButton *appleCashBT;
@property (weak, nonatomic) id<MSFViewModelServices> services;

@end

@implementation MSFSelectProductViewController

- (instancetype)initWithServices:(id)services {
    self = [UIStoryboard storyboardWithName:NSStringFromClass([MSFSelectProductViewController class]) bundle:nil].instantiateInitialViewController;
    if (!self) {
        return nil;
    }
    _services = services;
    
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
    [[self.jumpBT rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        MSFUser *user = [self.services httpClient].user;
        if (![user.custType isEqualToString:@"1"]) {
            if (self.returnSelectTabBatBlock != nil) {
                self.returnSelectTabBatBlock(@"0");
            }
            return ;
        }
        if (self.returnSelectTabBatBlock != nil) {
            self.returnSelectTabBatBlock(@"1");
        }        
    }];
    [[self.socialBT rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         MSFUser *user = [self.services httpClient].user;
         if (![user.custType isEqualToString:@"1"]) {
             [SVProgressHUD showInfoWithStatus:@"您所在的区域暂未开通，目前支持城市重庆"];
             return ;
         }
         if (self.returnSelectTabBatBlock != nil) {
             self.returnSelectTabBatBlock(@"1");
         }
     }];
    [[self.appleCashBT rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         if (self.returnSelectTabBatBlock != nil) {
             self.returnSelectTabBatBlock(@"0");
         }
     }];
}

- (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
}

- (void)returnBabBarWithBlock:(ReturnSelectTabBar)block {
    self.returnSelectTabBatBlock = block;
}

@end
