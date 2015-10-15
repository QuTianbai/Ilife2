//
// MSFAlertViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAlertViewController.h"
#import "MSFAlertContentViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFAlertViewModel.h"
#import "MSFReactiveView.h"

@interface MSFAlertViewController ()

@property (nonatomic, strong) MSFAlertViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) MSFAlertContentViewController *contentViewController;

@end

@implementation MSFAlertViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [UIStoryboard storyboardWithName:@"Alert" bundle:nil].instantiateInitialViewController;
	self.view.frame = CGRectMake(0, 0, 280, 320);
	self.viewModel = viewModel;
	[self.contentViewController bindViewModel:self.viewModel];
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	@weakify(self)
	[[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		[(RACSubject *)self.viewModel.buttonClickedSignal sendCompleted];
	}];
	[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		[(RACSubject *)self.viewModel.buttonClickedSignal sendNext:nil];
	}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	self.contentViewController = segue.destinationViewController;
}

@end
