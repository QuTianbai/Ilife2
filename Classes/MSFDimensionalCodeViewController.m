//
// MSFDimensionalCodeViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFDimensionalCodeViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFDimensionalCodeViewModel.h"

@interface MSFDimensionalCodeViewController ()

@property (nonatomic, strong) MSFDimensionalCodeViewModel *viewModel;

@end

@implementation MSFDimensionalCodeViewController

- (instancetype)initWithViewModel:(id)viewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	self.viewModel = viewModel;
	
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"扫描支付";
	self.view.backgroundColor = UIColor.whiteColor;
	UIImageView *imageview = [[UIImageView alloc] initWithFrame:UIScreen.mainScreen.bounds];
	imageview.contentMode = UIViewContentModeScaleAspectFit;
	[self.view addSubview:imageview];
	@weakify(imageview)
	[RACObserve(self, viewModel.dismensionalCodeURL) subscribeNext:^(id x) {
		@strongify(imageview)
		[imageview setImageWithURL:x];
	}];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-180, CGRectGetWidth([UIScreen mainScreen].bounds), 30)];
	label.text = self.viewModel.dismensionalCode;
	label.font = [UIFont boldSystemFontOfSize:17];
	label.textColor = UIColor.blackColor;
	label.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:label];
	
	UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-150, CGRectGetWidth([UIScreen mainScreen].bounds), 30)];
	title.font = [UIFont boldSystemFontOfSize:17];
	title.textColor = UIColor.blackColor;
	title.textAlignment = NSTextAlignmentCenter;
	title.text = self.viewModel.title;
	[self.view addSubview:title];
	
	UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-100, CGRectGetWidth([UIScreen mainScreen].bounds), 30)];
	subtitle.font = [UIFont boldSystemFontOfSize:17];
	subtitle.textColor = [UIColor colorWithRed:0.059 green:0.514 blue:1.000 alpha:1.000];
	subtitle.textAlignment = NSTextAlignmentCenter;
	subtitle.text = self.viewModel.subtitle;
	[self.view addSubview:subtitle];
	
	UILabel *timist = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth([UIScreen mainScreen].bounds), 30)];
	timist.font = [UIFont boldSystemFontOfSize:14];
	timist.textColor = UIColor.blackColor;
	timist.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:timist];
	
	RAC(timist, text) = RACObserve(self, viewModel.timist);
	
	@weakify(self)
	[self.viewModel.invalidSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.navigationController popViewControllerAnimated:YES];
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.viewModel.active = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	self.viewModel.active = NO;
}

@end
