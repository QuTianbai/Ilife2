//
//  MSFMyOrderListContainerViewController.m
//  Finance
//
//  Created by xbm on 16/3/2.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderListContainerViewController.h"
#import "MSFButtonSlidersView.h"
#import "UIColor+Utils.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFMyOrderListViewController.h"

@interface MSFMyOrderListContainerViewController () <MSFButtonSlidersDelegate>

@property (weak, nonatomic) IBOutlet MSFButtonSlidersView *buttonSliderView;
@end

@implementation MSFMyOrderListContainerViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFMyOrderListContainerViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFMyOrderListContainerViewController class])];
	if (!self) {
		return nil;
	}
	//self.viewModel = viewModel;
	
	return self;
	
}


- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"我的订单";
	self.view.backgroundColor = [UIColor darkBackgroundColor];
	self.buttonSliderView.delegate = self;
	[self.buttonSliderView buildButtonSliders:@[@"全部", @"马上贷", @"信用钱包", @"商品贷"] WithFrame:[UIScreen mainScreen].bounds];
	self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[MSFMyOrderListViewController class]]) {
		[(NSObject <MSFReactiveView> *)segue.destinationViewController bindViewModel:nil];
	}
}

@end
