//
// MSFCouponsContainerViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCouponsContainerViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCouponsViewController.h"
#import "MSFCouponsViewModel.h"
#import "MSFReactiveView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <KGModal/KGModal.h>
#import "MSFExchangeCouponViewController.h"

@interface MSFCouponsContainerViewController ()

@property (nonatomic, strong) MSFCouponsViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UIButton *button0;
@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (nonatomic, weak) IBOutlet UIView *indicator;
@property (nonatomic, assign) NSInteger index;

@end

@implementation MSFCouponsContainerViewController

- (instancetype)initWithViewModel:(id)viewModel {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([MSFCouponsContainerViewController class]) bundle:nil];
  self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSFCouponsContainerViewController class])];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"优惠券";
	self.index = 0;
	self.button0.enabled = NO;
	@weakify(self)
	[[self.button0 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.button0.enabled = NO;
		self.button1.enabled = YES;
		self.button2.enabled = YES;
		self.index = 0;
		[UIView animateWithDuration:.3 animations:^{
			CGPoint center = self.indicator.center;
			center.x = self.button0.center.x;
			self.indicator.center = center;
		}];
	}];
	[[self.button1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.button0.enabled = YES;
		self.button1.enabled = NO;
		self.button2.enabled = YES;
		self.index = 1;
		[UIView animateWithDuration:.3 animations:^{
			CGPoint center = self.indicator.center;
			center.x = self.button1.center.x;
			self.indicator.center = center;
		}];
	}];
	[[self.button2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.button0.enabled = YES;
		self.button1.enabled = YES;
		self.button2.enabled = NO;
		self.index = 2;
		[UIView animateWithDuration:.3 animations:^{
			CGPoint center = self.indicator.center;
			center.x = self.button2.center.x;
			self.indicator.center = center;
		}];
	}];
	
	[RACObserve(self, index) subscribeNext:^(id x) {
		@strongify(self)
		// B:领取未使用 C:已使用 D:已失效
		switch ([x integerValue]) {
			case 0:
				[self.viewModel.executeFetchCommand execute:@"B"];
				break;
			case 1:
				[self.viewModel.executeFetchCommand execute:@"C"];
				break;
			case 2:
				[self.viewModel.executeFetchCommand execute:@"D"];
				break;
			default:
				break;
		}
	}];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"兑换券" style:UIBarButtonItemStyleDone target:nil action:nil];
	item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self addCouponsSignal];
	}];
	self.navigationItem.rightBarButtonItem = item;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[MSFCouponsViewController class]]) {
		[(NSObject <MSFReactiveView> *)segue.destinationViewController bindViewModel:self.viewModel];
	}
}

- (RACSignal *)addCouponsSignal {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		MSFExchangeCouponViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MSFExchangeCouponViewController class])];
		vc.view.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 40, 180);
		[[KGModal sharedInstance] setCloseButtonLocation:KGModalCloseButtonLocationRight];
		[[KGModal sharedInstance] setModalBackgroundColor:[UIColor whiteColor]];
		[[KGModal sharedInstance] showWithContentViewController:vc andAnimated:YES];
		[[KGModal sharedInstance] setBackgroundDisplayStyle:KGModalBackgroundDisplayStyleSolid];
		
		[[[NSNotificationCenter defaultCenter] rac_addObserverForName:KGModalDidHideNotification object:nil] subscribeNext:^(id x) {
			[subscriber sendCompleted];
		}];
		
		[[vc.textField rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(id x) {
			vc.errorLabel.hidden = YES;
		}];
		
		[[vc.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
			[SVProgressHUD showWithStatus:@"正在兑换..."];
			[[self.viewModel.executeAdditionCommand execute:vc.textField.text] subscribeNext:^(id x) {
				[[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^{
					[subscriber sendCompleted];
					[SVProgressHUD showSuccessWithStatus:@"兑换成功"];
				}];
			} error:^(NSError *error) {
				[SVProgressHUD dismiss];
				vc.errorLabel.hidden = NO;
				vc.errorLabel.text = error.userInfo[NSLocalizedFailureReasonErrorKey];
			}];
		}];
		return [RACDisposable disposableWithBlock:^{
		}];
	}];
}

@end
