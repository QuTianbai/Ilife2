//
// MSFCommitedViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCommitedViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFEdgeButton.h"

@interface MSFCommitedViewController ()

@property (nonatomic, weak) IBOutlet MSFEdgeButton *button;

@end

@implementation MSFCommitedViewController

#pragma mark - NSObject

- (instancetype)init {
  self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFCommitedViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFCommitedViewController class])];
  if (!self) {
    return nil;
  }
	self.hidesBottomBarWhenPushed = YES;
  
  return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"提交成功";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
	@weakify(self)
	[[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		[self.navigationController popToRootViewControllerAnimated:YES];
	}];
}

- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
