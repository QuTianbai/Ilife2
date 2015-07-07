//
// MSFProgressHUD.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

static MBProgressHUD *hudInstance;

@implementation MSFProgressHUD

+ (void)showSuccessMessage:(NSString *)message inView:(UIView *)view {
  if (!view) {
    return;
  }
  [hudInstance hide:NO];
  hudInstance = [MBProgressHUD showHUDAddedTo:view animated:YES];
  hudInstance.mode = MBProgressHUDModeText;
  hudInstance.labelText = message;
  hudInstance.margin = 10.f;
  hudInstance.yOffset = 200;
  hudInstance.removeFromSuperViewOnHide = YES;
  [hudInstance hide:YES afterDelay:2];
}

+ (void)showErrorMessage:(NSString *)message inView:(UIView *)view {
  if (!view) {
    return;
  }
  [hudInstance hide:NO];
  hudInstance = [MBProgressHUD showHUDAddedTo:view animated:YES];
  hudInstance.mode = MBProgressHUDModeText;
  hudInstance.labelText = message;
  hudInstance.margin = 10.f;
  hudInstance.yOffset = 200;
  hudInstance.removeFromSuperViewOnHide = YES;
  [hudInstance hide:YES afterDelay:2];
}

+ (void)showStatusMessage:(NSString *)message inView:(UIView *)view {
  if (!view) {
    return;
  }
  [hudInstance hide:NO];
  hudInstance = [MBProgressHUD showHUDAddedTo:view animated:YES];
  hudInstance.labelText = message;
  hudInstance.removeFromSuperViewOnHide = YES;
  [hudInstance hide:YES afterDelay:30];
}

+ (void)hidden {
  [hudInstance hide:YES];
}

+ (void)showAlertTitle:(NSString *)title message:(NSString *)message {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
	[alertView show];
}

@end
