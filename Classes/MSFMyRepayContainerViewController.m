//
//  MSFMyRepayContainerViewController.m
//  Finance
//
//  Created by xbm on 16/2/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayContainerViewController.h"
#import "MSFButtonSlidersView.h"
#import "UIColor+Utils.h"
#import "MSFMyRepayTableViewController.h"
#import "MSFMyRepayViewModel.h"

@interface MSFMyRepayContainerViewController () <MSFButtonSlidersDelegate>
@property (weak, nonatomic) IBOutlet MSFButtonSlidersView *buttonSliderView;
@property (nonatomic, strong) MSFMyRepayViewModel *viewModel;
@end

@implementation MSFMyRepayContainerViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFMyRepayContainerViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFMyRepayContainerViewController class])];
	if (!self) {
		return nil;
	}
	self.viewModel = viewModel;
	
	return self;
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"我的还款";
	self.view.backgroundColor = [UIColor darkBackgroundColor];
	self.buttonSliderView.delegate = self;
	[self.buttonSliderView buildButtonSliders:@[@"全部", @"马上贷", @"信用钱包", @"商品贷"] WithFrame:[UIScreen mainScreen].bounds];
	self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[MSFMyRepayTableViewController class]]) {
		[(NSObject <MSFReactiveView> *)segue.destinationViewController bindViewModel:self.viewModel];
	}
}

#pragma mark msfButtonSliderDelegate

- (void)didSelectButtonForIndex:(NSInteger)buttonIndex {
	
}

@end
