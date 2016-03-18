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
#import "MSFMyOderListsViewModel.h"

@interface MSFMyOrderListContainerViewController () <MSFButtonSlidersDelegate>

@property (weak, nonatomic) IBOutlet MSFButtonSlidersView *buttonSliderView;
@property (nonatomic, strong) MSFMyOderListsViewModel *viewModel;

@end

@implementation MSFMyOrderListContainerViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [[UIStoryboard storyboardWithName:@"MyOrderList" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFMyOrderListContainerViewController class])];
	if (!self) {
		return nil;
	}
	self.hidesBottomBarWhenPushed = YES;
	self.viewModel = viewModel;
	
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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.viewModel.active = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	self.viewModel.active = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[MSFMyOrderListViewController class]]) {
		[(NSObject <MSFReactiveView> *)segue.destinationViewController bindViewModel:self.viewModel];
	}
}

#pragma mark msfButtonSliderDelegate

- (void)didSelectButtonForIndex:(NSInteger)buttonIndex {
	switch (buttonIndex - 1000) {
		case 0:
			[self.viewModel.executeFetchCommand execute:@"0"];
			break;
		case 1:
			[self.viewModel.executeFetchCommand execute:@"1"];
			break;
		case 2:
			[self.viewModel.executeFetchCommand execute:@"4"];
			break;
		case 3:
			[self.viewModel.executeFetchCommand execute:@"3"];
			break;
		default:
			break;
	}
	
}

@end
