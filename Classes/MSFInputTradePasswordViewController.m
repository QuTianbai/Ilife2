//
//  MSFInputTradePasswordViewController.m
//  Finance
//
//  Created by xbm on 15/9/30.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFInputTradePasswordViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <IQKeyboardManager/KeyboardManager.h>
#import "MSFGrayButton.h"
#import <NSString-Hashes/NSString+Hashes.h>

@interface MSFInputTradePasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *firstimg;
@property (weak, nonatomic) IBOutlet UIImageView *secondimg;
@property (weak, nonatomic) IBOutlet UIImageView *thirdimg;
@property (weak, nonatomic) IBOutlet UIImageView *forthimg;
@property (weak, nonatomic) IBOutlet UIImageView *fifthimg;
@property (weak, nonatomic) IBOutlet UIImageView *sixthimg;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@property (nonatomic, strong) NSArray *imgArray;
@property (weak, nonatomic) IBOutlet MSFGrayButton *cancelBT;

@end

@implementation MSFInputTradePasswordViewController

//!!!: 存在内存没有释放的问题

- (void)viewDidLoad {
	[super viewDidLoad];
	self.imgArray = @[
		self.firstimg,
		self.secondimg,
		self.thirdimg,
		self.forthimg,
		self.fifthimg,
		self.sixthimg
	];
	[self.pwdTF setInputAccessoryView:nil];
	[IQKeyboardManager sharedManager].enableAutoToolbar = NO;
	[[self.cancelBT rac_signalForControlEvents:UIControlEventTouchUpInside]
	subscribeNext:^(id x) {
		[IQKeyboardManager sharedManager].enableAutoToolbar = YES;
		[self.view removeFromSuperview];
		if ([self.delegate respondsToSelector:@selector(cancel)]) [self.delegate cancel];
	}];
	
	[[self.pwdTF rac_signalForControlEvents:UIControlEventEditingChanged]
	subscribeNext:^(UITextField *textField) {
		if (textField.text.length < 7) {
			for (int i = 0; i< 6; i++) {
				UIImageView *imgView = self.imgArray[i];
				if (i < textField.text.length) {
					if (imgView.hidden) {
						imgView.hidden = NO;
					}
				} else {
					if (!imgView.hidden) {
						imgView.hidden = YES;
					}
				}
				
			}
		} else {
			textField.text = [textField.text substringToIndex:6];
		}
		
		if (textField.text.length == 6) {
			[self.view removeFromSuperview];
			if ([self.delegate respondsToSelector:@selector(getTradePassword:type:)]) {
					[IQKeyboardManager sharedManager].enableAutoToolbar = YES;
				[self.delegate getTradePassword:textField.text.sha256 type:self.type];
			}
		}
		
	}];
	
	[[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
		for (UIImageView *imgView in self.imgArray) {
			imgView.hidden = YES;
		}
		[self.pwdTF becomeFirstResponder];
		self.pwdTF.text = @"";
	}];
}

@end
