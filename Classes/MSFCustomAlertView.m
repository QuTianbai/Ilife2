//
//  CustomAlertView.m
//  alert
//
//  Created by xbm on 15/9/1.
//  Copyright (c) 2015年 xbm. All rights reserved.
//

#import "MSFCustomAlertView.h"
#import "MSFCustomAlertViewController.h"
#import "MSFConfirmContractViewModel.h"

NSString *const MSFREQUESTCONTRACTSNOTIFACATION = @"MSFREQUESTCONTRACTSNOTIFACATION";
NSString *const MSFCONFIRMCONTACTNOTIFACATION = @"MSFCONFIRMCONTACTNOTIFACATION";
NSString *const MSFCONFIRMCONTACTIONLATERNOTIFICATION = @"MSFCONFIRMCONTACTIONLATERNOTIFICATION";

@interface MSFCustomAlertView ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *cancleTitle;
@property (nonatomic, copy) NSString *confirmTitle;
@property (nonatomic, strong) MSFCustomAlertViewController *myRootViewController;

@end

@implementation MSFCustomAlertView

- (instancetype)initAlertViewWithFrame:(CGRect)frame  AndTitle:(NSString *)title AndMessage:(NSString *)message AndImage:(UIImage *)image andCancleButtonTitle:(NSString *)cancleButton AndConfirmButtonTitle:(NSString *)confirmTitle {
	self = [super initWithFrame:frame];
	if (!self) {
		return nil;
	}
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
	_title = title;
	_message = message;
	_image = image;
	_cancleTitle = cancleButton;
	_confirmTitle = confirmTitle;
	[self createView];
	
	return self;
}

- (void)showWithViewModel:(MSFConfirmContractViewModel *)viewmodel {
	self.myRootViewController.viewModel = viewmodel;
	[self.myRootViewController bindBTRACCommand];
	[self makeKeyAndVisible];
}

- (void)dismiss {
	[self removeFromSuperview];
}

- (void)createView {
	 self.myRootViewController = [[MSFCustomAlertViewController alloc] init];
	self.myRootViewController.view.backgroundColor = self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
	self.rootViewController = self.myRootViewController;
}

@end
