//
// CHDocumentsSwapController.h
//
// Copyright (c) 2014 Zēng Liàng. All rights reserved.
//

#import "MSFLoginSwapController.h"

static NSString *const MSFLoginSignInIdentifier = @"signin";
static NSString *const MSFLoginSignUpIdentifier = @"signup";

@interface MSFLoginSwapController ()

@property (nonatomic, copy, readwrite) NSString *identifier;
@property (nonatomic, strong, readwrite) UIViewController *contentViewController;

@end

@implementation MSFLoginSwapController

#pragma mark - Lifecycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	UIViewController *newViewController = (UIViewController *)segue.destinationViewController;
	[newViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[newViewController.view setFrame:self.view.bounds];
	
	if ([self.childViewControllers containsObject:newViewController]) {
		[self.childViewControllers.lastObject didMoveToParentViewController:nil];
		[newViewController didMoveToParentViewController:self];
	} else {
		[self addChildViewController:newViewController];
		[self.view addSubview:newViewController.view];
		[newViewController didMoveToParentViewController:self];
	}
	
	self.identifier = segue.identifier;
  self.contentViewController = (UIViewController *)segue.destinationViewController;
}

- (void)swap:(MSFLoginType)type {
	switch (type) {
		case MSFLoginSignIn:
			[self performSegueWithIdentifier:MSFLoginSignInIdentifier sender:nil];
			break;
		case MSFLoginSignUp:
			[self performSegueWithIdentifier:MSFLoginSignUpIdentifier sender:nil];
			break;
	}
}

@end
