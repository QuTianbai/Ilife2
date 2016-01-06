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
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-120, CGRectGetWidth([UIScreen mainScreen].bounds), 30)];
	label.text = self.viewModel.dismensionalCode;
	label.font = [UIFont boldSystemFontOfSize:17];
	label.textColor = UIColor.blackColor;
	label.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:label];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.viewModel.active = YES;
}

@end
