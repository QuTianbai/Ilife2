//
// CHDocumentsSwapController.h
//
// Copyright (c) 2014 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MSFLoginType) {
	MSFLoginSignIn,
	MSFLoginSignUp,
};

@interface MSFLoginSwapController : UIViewController

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) UIViewController *contentViewController;

- (void)swap:(MSFLoginType)type;

@end
